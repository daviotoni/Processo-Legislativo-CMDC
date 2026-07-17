// Tipos do dominio (MVP). Espelham as tabelas do banco (db/schema.sql).

export type TipoProposicao = {
  id: number;
  nome: string;
  sigla: string;
  exige_sancao: boolean;
  turnos: number;
  quorum: string | null;
};

export type Fase = {
  id: number;
  nome: string;
  ordem: number;
  prazo_dias: number | null;
  is_inicial: boolean;
  is_final: boolean;
};

export type Orgao = {
  id: number;
  nome: string;
  sigla: string | null;
  grau: string;
};

export type Parlamentar = {
  id: number;
  nome: string;
  nome_parlamentar: string | null;
};

export type Proposicao = {
  id: number;
  processo_id: number | null;
  tipo_proposicao_id: number;
  numero: number | null;
  ano: number | null;
  ementa: string;
  texto: string | null;
  status_edicao: "RASCUNHO" | "PROTOCOLADA";
  nivel_sigilo: string;
  data_protocolo: string | null;
  criado_em: string;
};

export type Processo = {
  id: number;
  numero: number;
  ano: number;
  situacao_atual_id: number | null;
  orgao_atual_id: number | null;
  arquivado: boolean;
  motivo_arquivamento: string | null;
};

export type EventoTramitacao = {
  id: number;
  processo_id: number;
  tipo_evento: string;
  fase_destino_id: number | null;
  orgao_destino_id: number | null;
  incidente: string | null;
  observacao: string | null;
  prazo_vencimento: string | null;
  data_evento: string;
};
