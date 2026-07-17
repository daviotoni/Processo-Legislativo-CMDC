import Link from "next/link";
import { notFound } from "next/navigation";
import { supabaseAdmin } from "@/lib/supabase";
import { protocolar, moverFase, despachar, arquivar } from "../../actions";

export const dynamic = "force-dynamic";

export default async function DetalheProposicao({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const db = supabaseAdmin();

  const { data: p } = await db
    .from("proposicao")
    .select(
      `id, numero, ano, ementa, texto, status_edicao, nivel_sigilo, data_protocolo,
       tipo_proposicao(sigla, nome),
       autores:proposicao_autor(parlamentar(nome, nome_parlamentar)),
       processo(id, numero, ano, arquivado, situacao_atual_id,
                fase:situacao_atual_id(nome), orgao:orgao_atual_id(nome))`
    )
    .eq("id", Number(id))
    .single();

  if (!p) notFound();
  const prop = p as any;
  const sigla = prop.tipo_proposicao?.sigla ?? "?";
  const ident =
    prop.status_edicao === "PROTOCOLADA" && prop.numero
      ? `${sigla} ${String(prop.numero).padStart(3, "0")}/${prop.ano}`
      : `${sigla} — rascunho`;

  const processo = prop.processo;
  let eventos: any[] = [];
  let transicoes: any[] = [];
  let orgaos: any[] = [];
  if (processo) {
    const [ev, tr, og] = await Promise.all([
      db
        .from("evento_tramitacao")
        .select(
          "id, tipo_evento, observacao, incidente, prazo_vencimento, data_evento, fase_destino:fase_destino_id(nome), orgao_destino:orgao_destino_id(nome)"
        )
        .eq("processo_id", processo.id)
        .order("data_evento", { ascending: false }),
      db
        .from("transicao")
        .select("fase_destino_id, fase:fase_destino_id(nome)")
        .eq("fase_origem_id", processo.situacao_atual_id),
      db
        .from("orgao")
        .select("id, nome, sigla")
        .eq("ativo", true)
        .order("nome"),
    ]);
    eventos = ev.data ?? [];
    // Remove a auto-transicao (mesma fase) da lista de opcoes.
    transicoes = (tr.data ?? []).filter(
      (t: any) => t.fase_destino_id !== processo.situacao_atual_id
    );
    orgaos = og.data ?? [];
  }

  return (
    <>
      <p>
        <Link href="/proposicoes">← Proposicoes</Link>
      </p>
      <h1>{ident}</h1>
      <p>
        {prop.status_edicao === "RASCUNHO" ? (
          <span className="badge rascunho">Rascunho</span>
        ) : (
          <span className="badge protocolada">Protocolada</span>
        )}{" "}
        {processo?.fase && <span className="badge fase">{processo.fase.nome}</span>}
      </p>

      <div className="card">
        <p>
          <strong>Ementa:</strong> {prop.ementa}
        </p>
        <p className="muted">
          Tipo: {prop.tipo_proposicao?.nome} · Sigilo: {prop.nivel_sigilo}
          {processo && (
            <>
              {" "}
              · Processo {String(processo.numero).padStart(4, "0")}/{processo.ano}
              {processo.orgao && <> · Setor atual: {processo.orgao.nome}</>}
            </>
          )}
        </p>
        {prop.autores?.length > 0 && (
          <p className="muted">
            Autoria:{" "}
            {prop.autores
              .map(
                (a: any) =>
                  a.parlamentar?.nome_parlamentar ?? a.parlamentar?.nome
              )
              .filter(Boolean)
              .join(", ")}
          </p>
        )}
        {prop.texto && (
          <details>
            <summary>Texto</summary>
            <pre style={{ whiteSpace: "pre-wrap" }}>{prop.texto}</pre>
          </details>
        )}
      </div>

      {/* E1.2 Protocolo */}
      {prop.status_edicao === "RASCUNHO" && (
        <>
          <h2>Protocolar</h2>
          <form action={protocolar}>
            <input type="hidden" name="proposicao_id" value={prop.id} />
            <button type="submit">Protocolar e autuar</button>
          </form>
        </>
      )}

      {/* E1.3 / E1.4 / E1.6 acoes de tramitacao */}
      {processo && !processo.arquivado && (
        <>
          <h2>Tramitar</h2>
          <div className="row">
            <form action={moverFase}>
              <input type="hidden" name="processo_id" value={processo.id} />
              <label style={{ marginBottom: 6 }}>
                Mover para
                <select name="fase_destino_id" required defaultValue="">
                  <option value="" disabled>
                    Fase...
                  </option>
                  {transicoes.map((t: any) => (
                    <option key={t.fase_destino_id} value={t.fase_destino_id}>
                      {t.fase?.nome}
                    </option>
                  ))}
                </select>
              </label>
              <input name="observacao" placeholder="Observacao (opcional)" />
              <button type="submit" style={{ marginTop: 8 }}>
                Mover fase
              </button>
            </form>

            <form action={despachar}>
              <input type="hidden" name="processo_id" value={processo.id} />
              <label style={{ marginBottom: 6 }}>
                Despachar para setor
                <select name="orgao_destino_id" required defaultValue="">
                  <option value="" disabled>
                    Setor...
                  </option>
                  {orgaos.map((o: any) => (
                    <option key={o.id} value={o.id}>
                      {o.sigla ? `${o.sigla} — ` : ""}
                      {o.nome}
                    </option>
                  ))}
                </select>
              </label>
              <input name="observacao" placeholder="Observacao (opcional)" />
              <button type="submit" className="secondary" style={{ marginTop: 8 }}>
                Despachar
              </button>
            </form>

            <form action={arquivar}>
              <input type="hidden" name="processo_id" value={processo.id} />
              <label style={{ marginBottom: 6 }}>
                Arquivar
                <input name="motivo" placeholder="Motivo do arquivamento" />
              </label>
              <button type="submit" className="secondary" style={{ marginTop: 8 }}>
                Arquivar
              </button>
            </form>
          </div>
        </>
      )}

      {processo?.arquivado && (
        <p className="warn" style={{ marginTop: 16 }}>
          Processo arquivado{prop.processo?.motivo_arquivamento ? `: ${prop.processo.motivo_arquivamento}` : "."}
        </p>
      )}

      {/* Linha do tempo */}
      {processo && (
        <>
          <h2>Linha do tempo</h2>
          <ul className="timeline">
            {eventos.map((e: any) => (
              <li key={e.id}>
                <strong>{rotuloEvento(e.tipo_evento)}</strong>
                {e.fase_destino?.nome && <> → {e.fase_destino.nome}</>}
                {e.orgao_destino?.nome && <> → {e.orgao_destino.nome}</>}
                {e.observacao && <> · {e.observacao}</>}
                {e.prazo_vencimento && (
                  <> · prazo: {e.prazo_vencimento}</>
                )}
                <div className="muted" style={{ fontSize: ".8rem" }}>
                  {new Date(e.data_evento).toLocaleString("pt-BR")}
                </div>
              </li>
            ))}
          </ul>
        </>
      )}
    </>
  );
}

function rotuloEvento(tipo: string) {
  const map: Record<string, string> = {
    TRAMITACAO: "Tramitacao",
    DESPACHO: "Despacho",
    INCIDENTE: "Incidente",
    ARQUIVAMENTO: "Arquivamento",
    DESARQUIVAMENTO: "Desarquivamento",
  };
  return map[tipo] ?? tipo;
}
