import Link from "next/link";
import { supabaseAdmin } from "@/lib/supabase";

export const dynamic = "force-dynamic";

export default async function ListaProposicoes() {
  const db = supabaseAdmin();
  const { data, error } = await db
    .from("proposicao")
    .select(
      "id, numero, ano, ementa, status_edicao, tipo_proposicao(sigla), processo(situacao_atual_id, fase:situacao_atual_id(nome))"
    )
    .order("criado_em", { ascending: false })
    .limit(200);

  if (error) {
    return (
      <div className="warn">
        Erro ao carregar proposicoes: {error.message}
      </div>
    );
  }

  const rows = (data ?? []) as any[];

  return (
    <>
      <h1>Proposicoes</h1>
      <p>
        <Link className="btn" href="/proposicoes/nova">
          + Nova proposicao
        </Link>
      </p>

      {rows.length === 0 ? (
        <p className="muted">Nenhuma proposicao ainda. Crie a primeira.</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Identificacao</th>
              <th>Ementa</th>
              <th>Situacao</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((p) => {
              const sigla = p.tipo_proposicao?.sigla ?? "?";
              const id =
                p.status_edicao === "PROTOCOLADA" && p.numero
                  ? `${sigla} ${String(p.numero).padStart(3, "0")}/${p.ano}`
                  : `${sigla} (rascunho)`;
              const fase = p.processo?.fase?.nome;
              return (
                <tr key={p.id}>
                  <td>
                    <Link href={`/proposicoes/${p.id}`}>{id}</Link>
                  </td>
                  <td>{p.ementa}</td>
                  <td>
                    {p.status_edicao === "RASCUNHO" ? (
                      <span className="badge rascunho">Rascunho</span>
                    ) : (
                      <span className="badge fase">{fase ?? "Protocolada"}</span>
                    )}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      )}
    </>
  );
}
