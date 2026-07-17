-- =============================================================================
-- Sistema de Processo Legislativo — CMDC
-- Esquema do banco de dados (PostgreSQL / Supabase) — MVP (Fase 0 + Fase 1)
--
-- Derivado de docs/backlog-mvp.md. Cada bloco referencia a atribuicao legal
-- de origem (Lei no 3.525/2025). Nomes de tabela/coluna em snake_case.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- FASE 0 — Fundacao (parametrizacao)
-- -----------------------------------------------------------------------------

-- E0.1 Orgaos (estrutura da Lei 3.525/2025 — 4 graus + colegiados + gabinetes)
CREATE TABLE orgao (
    id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome         text    NOT NULL,
    sigla        text,
    grau         text    NOT NULL
                 CHECK (grau IN ('1_GRAU','2_GRAU','3_GRAU','4_GRAU',
                                 'COLEGIADO','GABINETE','MESA')),
    orgao_pai_id bigint  REFERENCES orgao(id),
    ativo        boolean NOT NULL DEFAULT true,
    criado_em    timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE orgao IS 'Estrutura administrativa da Lei 3.525/2025 (hierarquia via orgao_pai_id).';

-- E0.2 Cargos (Diretor-Geral, Coordenador, Assessor... — arts. 49,53,54,59)
CREATE TABLE cargo (
    id        bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome      text   NOT NULL,
    orgao_id  bigint REFERENCES orgao(id),
    criado_em timestamptz NOT NULL DEFAULT now()
);

-- E0.3 Usuarios, papeis e permissoes (TIC — administracao de sistemas)
CREATE TABLE usuario (
    id         bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome       text    NOT NULL,
    email      text    NOT NULL UNIQUE,
    senha_hash text    NOT NULL,
    orgao_id   bigint  REFERENCES orgao(id),   -- lotacao formal (dimensao ABAC)
    cargo_id   bigint  REFERENCES cargo(id),
    vinculo    text    NOT NULL DEFAULT 'COMISSIONADO'
               CHECK (vinculo IN ('EFETIVO','COMISSIONADO','REQUISITADO','FUNCAO_GRATIFICADA')),
    ativo      boolean NOT NULL DEFAULT true,
    criado_em  timestamptz NOT NULL DEFAULT now()
);
COMMENT ON COLUMN usuario.vinculo IS 'Tipo de vinculo; sustenta regras de elegibilidade (ex.: Controle Interno privativo de EFETIVO — Lei 3.525/2025, art. 51 par. unico).';

CREATE TABLE papel (
    id        bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome      text NOT NULL UNIQUE,          -- ex.: PROTOCOLO, TRAMITACAO, AUTOR_GABINETE, CONSULTA, ADMIN
    descricao text,
    exige_vinculo_efetivo boolean NOT NULL DEFAULT false  -- ex.: CONTROLE_INTERNO (art. 51 par. unico)
);

CREATE TABLE permissao (
    id    bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    acao  text NOT NULL UNIQUE,              -- ex.: proposicao.protocolar, tramitacao.despachar, processo.arquivar
    descricao text
);

CREATE TABLE papel_permissao (
    papel_id     bigint NOT NULL REFERENCES papel(id) ON DELETE CASCADE,
    permissao_id bigint NOT NULL REFERENCES permissao(id) ON DELETE CASCADE,
    PRIMARY KEY (papel_id, permissao_id)
);

CREATE TABLE usuario_papel (
    usuario_id bigint NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
    papel_id   bigint NOT NULL REFERENCES papel(id) ON DELETE CASCADE,
    PRIMARY KEY (usuario_id, papel_id)
);

-- Delegacao / substituicao formal (dimensao ABAC): permite que um usuario atue
-- temporariamente com o papel de outro, mediante ato formal e prazo. (arts. 3o, 5o, 44-47, 79)
CREATE TABLE delegacao (
    id                  bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    delegante_id        bigint NOT NULL REFERENCES usuario(id),
    delegado_id         bigint NOT NULL REFERENCES usuario(id),
    papel_id            bigint REFERENCES papel(id),     -- papel delegado (nulo = todos do delegante)
    orgao_id            bigint REFERENCES orgao(id),     -- escopo opcional
    ato_formal          text,                            -- ex.: Portaria/Designacao no XXX
    inicio              date NOT NULL,
    fim                 date,                            -- nulo = por prazo indeterminado
    ativo               boolean NOT NULL DEFAULT true,
    criado_em           timestamptz NOT NULL DEFAULT now(),
    CHECK (delegante_id <> delegado_id)
);
CREATE INDEX idx_delegacao_delegado ON delegacao (delegado_id, ativo);

-- E0.4 Tipos de proposicao (parametrizavel — regras variam por tipo)
CREATE TABLE tipo_proposicao (
    id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome         text    NOT NULL,           -- ex.: Projeto de Lei Ordinaria
    sigla        text    NOT NULL UNIQUE,     -- ex.: PL, PLC, PDL, PR, REQ, IND, MOC
    exige_sancao boolean NOT NULL DEFAULT true,
    turnos       smallint NOT NULL DEFAULT 1 CHECK (turnos IN (1,2)),
    quorum       text,                        -- ex.: MAIORIA_SIMPLES, MAIORIA_ABSOLUTA, DOIS_TERCOS
    ativo        boolean NOT NULL DEFAULT true
);

-- E0.5 Fases e prazos regimentais (maquina de estados parametrizavel)
-- Origem: art. 37/20/59 "controle do processo legislativo, observando fases e prazos".
CREATE TABLE fase (
    id                    bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome                  text     NOT NULL,
    ordem                 smallint NOT NULL,
    orgao_responsavel_id  bigint   REFERENCES orgao(id),
    prazo_dias            smallint,           -- nulo = sem prazo
    is_inicial            boolean  NOT NULL DEFAULT false,
    is_final              boolean  NOT NULL DEFAULT false
);

-- Transicoes permitidas entre fases (opcionalmente especificas por tipo)
CREATE TABLE transicao (
    id                 bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fase_origem_id     bigint NOT NULL REFERENCES fase(id),
    fase_destino_id    bigint NOT NULL REFERENCES fase(id),
    tipo_proposicao_id bigint REFERENCES tipo_proposicao(id),  -- nulo = vale para todos os tipos
    UNIQUE (fase_origem_id, fase_destino_id, tipo_proposicao_id)
);

-- E0.6 Legislaturas, parlamentares e comissoes (composicoes temporais)
CREATE TABLE legislatura (
    id         bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    numero     smallint NOT NULL,             -- ex.: 20 (20a legislatura)
    ano_inicio smallint NOT NULL,
    ano_fim    smallint NOT NULL
);

CREATE TABLE parlamentar (
    id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome           text NOT NULL,
    partido        text,
    legislatura_id bigint REFERENCES legislatura(id),
    situacao       text NOT NULL DEFAULT 'ATIVO'
                   CHECK (situacao IN ('ATIVO','LICENCIADO','SUPLENTE'))
);

CREATE TABLE comissao (
    id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome           text NOT NULL,
    classe         text NOT NULL CHECK (classe IN ('PERMANENTE','TEMPORARIA')),
    bienio_inicio  smallint,
    bienio_fim     smallint
);

CREATE TABLE comissao_membro (
    id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    comissao_id  bigint NOT NULL REFERENCES comissao(id) ON DELETE CASCADE,
    parlamentar_id bigint NOT NULL REFERENCES parlamentar(id),
    papel_comissao text NOT NULL
                   CHECK (papel_comissao IN ('PRESIDENTE','VICE','RELATOR','SUPLENTE_1','SUPLENTE_2'))
);

-- -----------------------------------------------------------------------------
-- FASE 1 — MVP: Protocolo e Controle do Processo Legislativo
-- -----------------------------------------------------------------------------

-- Processo = conteiner que acompanha a materia do protocolo ao arquivamento.
-- Carrega a situacao (fase) e o orgao atuais + arquivamento. (arts. 14, 37)
CREATE TABLE processo (
    id                   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    numero               integer NOT NULL,
    ano                  smallint NOT NULL,
    data_autuacao        timestamptz NOT NULL DEFAULT now(),
    situacao_atual_id    bigint REFERENCES fase(id),
    orgao_atual_id       bigint REFERENCES orgao(id),
    arquivado            boolean NOT NULL DEFAULT false,
    motivo_arquivamento  text,
    data_arquivamento    timestamptz,
    nivel_sigilo         text NOT NULL DEFAULT 'INTERNO'
                         CHECK (nivel_sigilo IN ('PUBLICO','INTERNO','RESTRITO_FUNCIONAL','RESTRITO_SENSIVEL')),
    UNIQUE (numero, ano)
);

-- E1.1/E1.2 Proposicao (conteudo legislativo). Rascunho -> Protocolada.
-- (art. 20 "conferir, digitar, controlar e expedir"; art. 35 "registrar proposicoes")
CREATE TABLE proposicao (
    id                 bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    processo_id        bigint REFERENCES processo(id),       -- nulo enquanto RASCUNHO
    tipo_proposicao_id bigint NOT NULL REFERENCES tipo_proposicao(id),
    numero             integer,                              -- atribuido no protocolo
    ano                smallint,
    ementa             text NOT NULL,
    texto              text,
    status_edicao      text NOT NULL DEFAULT 'RASCUNHO'
                       CHECK (status_edicao IN ('RASCUNHO','PROTOCOLADA')),
    nivel_sigilo       text NOT NULL DEFAULT 'PUBLICO'       -- proposicoes nascem publicas, salvo excecao legal
                       CHECK (nivel_sigilo IN ('PUBLICO','INTERNO','RESTRITO_FUNCIONAL','RESTRITO_SENSIVEL')),
    data_protocolo     timestamptz,
    criado_por         bigint REFERENCES usuario(id),
    criado_em          timestamptz NOT NULL DEFAULT now(),
    UNIQUE (tipo_proposicao_id, numero, ano)                 -- ex.: PL 001/2026 unico
);

CREATE TABLE proposicao_autor (
    id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    proposicao_id bigint NOT NULL REFERENCES proposicao(id) ON DELETE CASCADE,
    parlamentar_id bigint NOT NULL REFERENCES parlamentar(id),
    tipo_autoria  text NOT NULL DEFAULT 'PRINCIPAL'
                  CHECK (tipo_autoria IN ('PRINCIPAL','COAUTOR','SUBSCRITOR'))
);

CREATE TABLE anexo (
    id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    proposicao_id bigint NOT NULL REFERENCES proposicao(id) ON DELETE CASCADE,
    nome          text NOT NULL,
    tipo_mime     text,
    caminho       text NOT NULL,                             -- storage (ex.: Supabase Storage)
    tamanho_bytes bigint,
    hash_sha256   text,                                      -- cadeia de custodia / integridade
    nivel_sigilo  text NOT NULL DEFAULT 'INTERNO'
                  CHECK (nivel_sigilo IN ('PUBLICO','INTERNO','RESTRITO_FUNCIONAL','RESTRITO_SENSIVEL')),
    enviado_por   bigint REFERENCES usuario(id),
    criado_em     timestamptz NOT NULL DEFAULT now()
);

-- E1.3/E1.4 Eventos de tramitacao (historico IMUTAVEL) + despachos + incidentes
-- (art. 37 distribuicao de documentos; art. 20 encaminhamento; fases/prazos)
CREATE TABLE evento_tramitacao (
    id               bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    processo_id      bigint NOT NULL REFERENCES processo(id) ON DELETE CASCADE,
    tipo_evento      text NOT NULL
                     CHECK (tipo_evento IN ('TRAMITACAO','DESPACHO','INCIDENTE',
                                            'ARQUIVAMENTO','DESARQUIVAMENTO')),
    fase_origem_id   bigint REFERENCES fase(id),
    fase_destino_id  bigint REFERENCES fase(id),
    orgao_origem_id  bigint REFERENCES orgao(id),
    orgao_destino_id bigint REFERENCES orgao(id),
    incidente        text,                                   -- VISTA, DILIGENCIA, ADIAMENTO, PREJUDICIALIDADE...
    observacao       text,
    prazo_vencimento  date,                                  -- calculado a partir de fase.prazo_dias
    responsavel_id   bigint REFERENCES usuario(id),
    data_evento      timestamptz NOT NULL DEFAULT now()
);

-- E1.6 Cadastro de leis municipais (art. 37 "manter cadastro de leis atualizado")
CREATE TABLE lei (
    id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    numero         integer NOT NULL,
    ano            smallint NOT NULL,
    tipo           text,                                     -- ORDINARIA, COMPLEMENTAR, RESOLUCAO, DECRETO_LEGISLATIVO
    data_norma     date,
    ementa         text NOT NULL,
    proposicao_id  bigint REFERENCES proposicao(id),         -- processo de origem
    UNIQUE (tipo, numero, ano)
);

-- E1.5 Notificacoes (manter autor/Presidente informados — arts. 37, 35)
CREATE TABLE notificacao (
    id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id    bigint NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
    processo_id   bigint REFERENCES processo(id) ON DELETE CASCADE,
    mensagem      text NOT NULL,
    lida          boolean NOT NULL DEFAULT false,
    criado_em     timestamptz NOT NULL DEFAULT now()
);

-- E1.7 Trilha de auditoria (log imutavel — TIC/Controladoria/LGPD)
CREATE TABLE log_auditoria (
    id               bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id       bigint REFERENCES usuario(id),
    acao             text NOT NULL,                          -- ex.: PROTOCOLAR, DESPACHAR, ARQUIVAR, EDITAR
    entidade         text NOT NULL,                          -- ex.: proposicao, processo
    entidade_id      bigint,
    dados_anteriores jsonb,
    dados_novos      jsonb,
    ip               inet,
    data_hora        timestamptz NOT NULL DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- Indices para consultas frequentes (E1.5 busca e caixas de trabalho)
-- -----------------------------------------------------------------------------
CREATE INDEX idx_proposicao_tipo_ano   ON proposicao (tipo_proposicao_id, ano);
CREATE INDEX idx_proposicao_status     ON proposicao (status_edicao);
CREATE INDEX idx_processo_situacao     ON processo (situacao_atual_id);
CREATE INDEX idx_processo_orgao_atual  ON processo (orgao_atual_id);
CREATE INDEX idx_evento_processo       ON evento_tramitacao (processo_id, data_evento);
CREATE INDEX idx_evento_orgao_destino  ON evento_tramitacao (orgao_destino_id);
CREATE INDEX idx_notificacao_usuario   ON notificacao (usuario_id, lida);
CREATE INDEX idx_auditoria_entidade    ON log_auditoria (entidade, entidade_id);
