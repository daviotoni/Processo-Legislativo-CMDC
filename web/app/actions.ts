"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { supabaseAdmin } from "@/lib/supabase";

// Registra uma acao na trilha de auditoria (E1.7).
async function audit(
  acao: string,
  entidade: string,
  entidade_id: number,
  dados_novos?: unknown
) {
  const db = supabaseAdmin();
  await db.from("log_auditoria").insert({
    acao,
    entidade,
    entidade_id,
    dados_novos: dados_novos ?? null,
  });
}

// E1.1 — cria proposicao em RASCUNHO (ainda sem numero).
export async function criarRascunho(formData: FormData) {
  const db = supabaseAdmin();
  const tipo_proposicao_id = Number(formData.get("tipo_proposicao_id"));
  const ementa = String(formData.get("ementa") ?? "").trim();
  const texto = String(formData.get("texto") ?? "").trim() || null;
  const autorId = formData.get("parlamentar_id");

  if (!tipo_proposicao_id || !ementa) {
    throw new Error("Tipo e ementa sao obrigatorios.");
  }

  const { data, error } = await db
    .from("proposicao")
    .insert({ tipo_proposicao_id, ementa, texto, status_edicao: "RASCUNHO" })
    .select("id")
    .single();
  if (error) throw new Error(error.message);

  if (autorId) {
    await db.from("proposicao_autor").insert({
      proposicao_id: data.id,
      parlamentar_id: Number(autorId),
      tipo_autoria: "PRINCIPAL",
    });
  }
  await audit("CRIAR_RASCUNHO", "proposicao", data.id, { ementa });
  revalidatePath("/proposicoes");
  redirect(`/proposicoes/${data.id}`);
}

// E1.2 — protocola/autua: atribui numero, cria o processo e inicia a tramitacao.
export async function protocolar(formData: FormData) {
  const db = supabaseAdmin();
  const proposicaoId = Number(formData.get("proposicao_id"));

  const { data: prop, error: e1 } = await db
    .from("proposicao")
    .select("id, tipo_proposicao_id, status_edicao")
    .eq("id", proposicaoId)
    .single();
  if (e1) throw new Error(e1.message);
  if (prop.status_edicao !== "RASCUNHO") {
    throw new Error("Proposicao ja protocolada.");
  }

  const ano = new Date().getFullYear();

  // Proximo numero da proposicao (por tipo/ano).
  const { data: ult } = await db
    .from("proposicao")
    .select("numero")
    .eq("tipo_proposicao_id", prop.tipo_proposicao_id)
    .eq("ano", ano)
    .order("numero", { ascending: false })
    .limit(1);
  const numero = (ult?.[0]?.numero ?? 0) + 1;

  // Proximo numero do processo (por ano).
  const { data: ultProc } = await db
    .from("processo")
    .select("numero")
    .eq("ano", ano)
    .order("numero", { ascending: false })
    .limit(1);
  const numeroProcesso = (ultProc?.[0]?.numero ?? 0) + 1;

  // Fase inicial e orgao de protocolo (Secretaria-Geral).
  const { data: faseInicial } = await db
    .from("fase")
    .select("id")
    .eq("is_inicial", true)
    .limit(1)
    .single();
  const { data: csg } = await db
    .from("orgao")
    .select("id")
    .eq("sigla", "CSG")
    .limit(1)
    .single();

  const { data: proc, error: e2 } = await db
    .from("processo")
    .insert({
      numero: numeroProcesso,
      ano,
      situacao_atual_id: faseInicial?.id ?? null,
      orgao_atual_id: csg?.id ?? null,
    })
    .select("id")
    .single();
  if (e2) throw new Error(e2.message);

  const { error: e3 } = await db
    .from("proposicao")
    .update({
      numero,
      ano,
      status_edicao: "PROTOCOLADA",
      data_protocolo: new Date().toISOString(),
      processo_id: proc.id,
    })
    .eq("id", proposicaoId);
  if (e3) throw new Error(e3.message);

  await db.from("evento_tramitacao").insert({
    processo_id: proc.id,
    tipo_evento: "TRAMITACAO",
    fase_destino_id: faseInicial?.id ?? null,
    orgao_destino_id: csg?.id ?? null,
    observacao: "Protocolo e autuacao",
  });
  await audit("PROTOCOLAR", "proposicao", proposicaoId, { numero, ano });
  revalidatePath(`/proposicoes/${proposicaoId}`);
  revalidatePath("/proposicoes");
}

// E1.3 — move a fase respeitando as transicoes configuradas.
export async function moverFase(formData: FormData) {
  const db = supabaseAdmin();
  const processoId = Number(formData.get("processo_id"));
  const faseDestinoId = Number(formData.get("fase_destino_id"));
  const observacao = String(formData.get("observacao") ?? "").trim() || null;

  const { data: proc, error: e1 } = await db
    .from("processo")
    .select("id, situacao_atual_id")
    .eq("id", processoId)
    .single();
  if (e1) throw new Error(e1.message);

  // Valida se a transicao e permitida (tipo NULL = vale para todos).
  const { data: transicoes } = await db
    .from("transicao")
    .select("id")
    .eq("fase_origem_id", proc.situacao_atual_id)
    .eq("fase_destino_id", faseDestinoId)
    .limit(1);
  if (!transicoes || transicoes.length === 0) {
    throw new Error("Transicao nao permitida pelo fluxo configurado.");
  }

  const { data: faseDestino } = await db
    .from("fase")
    .select("id, prazo_dias")
    .eq("id", faseDestinoId)
    .single();

  let prazo: string | null = null;
  if (faseDestino?.prazo_dias) {
    const d = new Date();
    d.setDate(d.getDate() + faseDestino.prazo_dias);
    prazo = d.toISOString().slice(0, 10);
  }

  await db
    .from("processo")
    .update({ situacao_atual_id: faseDestinoId })
    .eq("id", processoId);

  await db.from("evento_tramitacao").insert({
    processo_id: processoId,
    tipo_evento: "TRAMITACAO",
    fase_origem_id: proc.situacao_atual_id,
    fase_destino_id: faseDestinoId,
    observacao,
    prazo_vencimento: prazo,
  });
  await audit("MOVER_FASE", "processo", processoId, { faseDestinoId });
  revalidatePath("/proposicoes");
}

// E1.4 — despacho entre setores (muda o orgao atual).
export async function despachar(formData: FormData) {
  const db = supabaseAdmin();
  const processoId = Number(formData.get("processo_id"));
  const orgaoDestinoId = Number(formData.get("orgao_destino_id"));
  const observacao = String(formData.get("observacao") ?? "").trim() || null;

  const { data: proc } = await db
    .from("processo")
    .select("orgao_atual_id")
    .eq("id", processoId)
    .single();

  await db
    .from("processo")
    .update({ orgao_atual_id: orgaoDestinoId })
    .eq("id", processoId);

  await db.from("evento_tramitacao").insert({
    processo_id: processoId,
    tipo_evento: "DESPACHO",
    orgao_origem_id: proc?.orgao_atual_id ?? null,
    orgao_destino_id: orgaoDestinoId,
    observacao,
  });
  await audit("DESPACHAR", "processo", processoId, { orgaoDestinoId });
  revalidatePath("/proposicoes");
}

// E1.6 — arquivamento.
export async function arquivar(formData: FormData) {
  const db = supabaseAdmin();
  const processoId = Number(formData.get("processo_id"));
  const motivo = String(formData.get("motivo") ?? "").trim() || null;

  const { data: faseArq } = await db
    .from("fase")
    .select("id")
    .eq("nome", "Arquivada")
    .limit(1)
    .single();

  await db
    .from("processo")
    .update({
      arquivado: true,
      motivo_arquivamento: motivo,
      data_arquivamento: new Date().toISOString(),
      situacao_atual_id: faseArq?.id ?? null,
    })
    .eq("id", processoId);

  await db.from("evento_tramitacao").insert({
    processo_id: processoId,
    tipo_evento: "ARQUIVAMENTO",
    fase_destino_id: faseArq?.id ?? null,
    observacao: motivo,
  });
  await audit("ARQUIVAR", "processo", processoId, { motivo });
  revalidatePath("/proposicoes");
}
