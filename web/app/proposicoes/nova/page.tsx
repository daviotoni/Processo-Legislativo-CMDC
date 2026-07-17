import { supabaseAdmin } from "@/lib/supabase";
import { criarRascunho } from "../../actions";

export const dynamic = "force-dynamic";

export default async function NovaProposicao() {
  const db = supabaseAdmin();
  const [{ data: tipos }, { data: autores }] = await Promise.all([
    db.from("tipo_proposicao").select("id, nome, sigla").eq("ativo", true).order("nome"),
    db
      .from("parlamentar")
      .select("id, nome, nome_parlamentar")
      .order("nome_parlamentar"),
  ]);

  return (
    <>
      <h1>Nova proposicao</h1>
      <p className="muted">
        Cria um rascunho (E1.1). O numero oficial e atribuido no protocolo.
      </p>

      <form action={criarRascunho} style={{ maxWidth: 640, marginTop: 12 }}>
        <label>
          Tipo de proposicao *
          <select name="tipo_proposicao_id" required defaultValue="">
            <option value="" disabled>
              Selecione...
            </option>
            {(tipos ?? []).map((t) => (
              <option key={t.id} value={t.id}>
                {t.sigla} — {t.nome}
              </option>
            ))}
          </select>
        </label>

        <label>
          Autor (vereador)
          <select name="parlamentar_id" defaultValue="">
            <option value="">— sem autor —</option>
            {(autores ?? []).map((a) => (
              <option key={a.id} value={a.id}>
                {a.nome_parlamentar ?? a.nome}
              </option>
            ))}
          </select>
        </label>

        <label>
          Ementa *
          <textarea name="ementa" required rows={2} placeholder="Resumo do objeto da proposicao" />
        </label>

        <label>
          Texto
          <textarea name="texto" rows={8} placeholder="Texto da proposicao" />
        </label>

        <button type="submit">Salvar rascunho</button>
      </form>
    </>
  );
}
