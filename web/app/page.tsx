import Link from "next/link";
import { supabaseAdmin } from "@/lib/supabase";

export const dynamic = "force-dynamic";

async function contar(tabela: string, filtro?: (q: any) => any) {
  const db = supabaseAdmin();
  let q = db.from(tabela).select("*", { count: "exact", head: true });
  if (filtro) q = filtro(q);
  const { count } = await q;
  return count ?? 0;
}

export default async function Home() {
  let stats: { l: string; n: number }[] = [];
  let erro: string | null = null;
  try {
    const [proposicoes, rascunhos, protocoladas, orgaos, vereadores, comissoes] =
      await Promise.all([
        contar("proposicao"),
        contar("proposicao", (q) => q.eq("status_edicao", "RASCUNHO")),
        contar("proposicao", (q) => q.eq("status_edicao", "PROTOCOLADA")),
        contar("orgao"),
        contar("parlamentar"),
        contar("comissao"),
      ]);
    stats = [
      { l: "Proposicoes", n: proposicoes },
      { l: "Rascunhos", n: rascunhos },
      { l: "Protocoladas", n: protocoladas },
      { l: "Orgaos", n: orgaos },
      { l: "Vereadores", n: vereadores },
      { l: "Comissoes", n: comissoes },
    ];
  } catch (e) {
    erro = e instanceof Error ? e.message : String(e);
  }

  return (
    <>
      <h1>Painel</h1>
      <p className="muted">
        Sistema de Processo Legislativo da Camara Municipal de Duque de Caxias.
      </p>

      {erro ? (
        <div className="warn">
          <strong>Sem conexao com o banco.</strong> {erro}
          <br />
          Configure <code>web/.env.local</code> (veja <code>.env.example</code>).
        </div>
      ) : (
        <div className="grid" style={{ marginTop: 16 }}>
          {stats.map((s) => (
            <div className="card stat" key={s.l}>
              <div className="n">{s.n}</div>
              <div className="l">{s.l}</div>
            </div>
          ))}
        </div>
      )}

      <h2>Acoes</h2>
      <p>
        <Link className="btn" href="/proposicoes/nova">
          + Nova proposicao
        </Link>{" "}
        <Link href="/proposicoes" style={{ marginLeft: 12 }}>
          Ver todas as proposicoes
        </Link>
      </p>
    </>
  );
}
