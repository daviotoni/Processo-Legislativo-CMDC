-- =============================================================================
-- Dados iniciais (seed) — Sistema de Processo Legislativo CMDC
-- Executar APOS db/schema.sql. Valores a validar com a Secretaria-Geral.
-- =============================================================================

-- Tipos de proposicao (ver docs/processo-legislativo.md)
INSERT INTO tipo_proposicao (nome, sigla, exige_sancao, turnos, quorum) VALUES
 ('Emenda a Lei Organica',        'PEC-LOM', false, 2, 'DOIS_TERCOS'),
 ('Projeto de Lei Complementar',  'PLC',     true,  1, 'MAIORIA_ABSOLUTA'),
 ('Projeto de Lei Ordinaria',     'PL',      true,  1, 'MAIORIA_SIMPLES'),
 ('Projeto de Decreto Legislativo','PDL',    false, 1, 'MAIORIA_SIMPLES'),
 ('Projeto de Resolucao',         'PR',      false, 1, 'MAIORIA_SIMPLES'),
 ('Indicacao',                    'IND',     false, 1, 'MAIORIA_SIMPLES'),
 ('Requerimento',                 'REQ',     false, 1, 'MAIORIA_SIMPLES'),
 ('Mocao',                        'MOC',     false, 1, 'MAIORIA_SIMPLES');

-- Papeis (E0.3)
INSERT INTO papel (nome, descricao) VALUES
 ('ADMIN',         'Administracao do sistema (TIC)'),
 ('PROTOCOLO',     'Protocolar e autuar proposicoes (Secretaria-Geral)'),
 ('TRAMITACAO',    'Despachar e movimentar processos'),
 ('AUTOR_GABINETE','Registrar proposicoes e acompanhar (Gabinetes)'),
 ('CONSULTA',      'Somente consulta');

-- Permissoes (E0.3 / E1.7)
INSERT INTO permissao (acao, descricao) VALUES
 ('proposicao.criar',     'Criar/editar rascunho de proposicao'),
 ('proposicao.protocolar','Protocolar e autuar'),
 ('tramitacao.despachar', 'Despachar entre setores'),
 ('tramitacao.mover',     'Mover fase da tramitacao'),
 ('processo.arquivar',    'Arquivar/desarquivar processo'),
 ('lei.gerenciar',        'Manter cadastro de leis'),
 ('cadastro.gerenciar',   'Gerenciar cadastros/parametrizacao'),
 ('consulta.ler',         'Consultar proposicoes e processos');

-- Fluxo de fases PADRAO (E0.5) — simplificado; refinar com o Regimento Interno.
INSERT INTO fase (nome, ordem, prazo_dias, is_inicial, is_final) VALUES
 ('Protocolada',            10, NULL, true,  false),
 ('Aguardando Distribuicao',20, 5,    false, false),
 ('Em Comissao',            30, 15,   false, false),
 ('Aguardando Pauta',       40, NULL, false, false),
 ('Em Pauta',               50, NULL, false, false),
 ('Em Deliberacao',         60, NULL, false, false),
 ('Aprovada',               70, NULL, false, false),
 ('Rejeitada',              75, NULL, false, true),
 ('Redacao Final',          80, 5,    false, false),
 ('Encaminhada a Sancao',   90, 15,   false, false),
 ('Promulgada/Publicada',  100, NULL, false, false),
 ('Arquivada',             110, NULL, false, true);

-- Transicoes lineares padrao (validas para todos os tipos: tipo_proposicao_id = NULL).
-- Usa subselect por nome para nao depender de IDs fixos.
INSERT INTO transicao (fase_origem_id, fase_destino_id)
SELECT o.id, d.id FROM fase o, fase d WHERE (o.nome, d.nome) IN (
 ('Protocolada','Aguardando Distribuicao'),
 ('Aguardando Distribuicao','Em Comissao'),
 ('Em Comissao','Aguardando Pauta'),
 ('Aguardando Pauta','Em Pauta'),
 ('Em Pauta','Em Deliberacao'),
 ('Em Deliberacao','Aprovada'),
 ('Em Deliberacao','Rejeitada'),
 ('Aprovada','Redacao Final'),
 ('Redacao Final','Encaminhada a Sancao'),
 ('Encaminhada a Sancao','Promulgada/Publicada'),
 ('Promulgada/Publicada','Arquivada'),
 ('Rejeitada','Arquivada'),
 -- retorno a comissao (diligencia) e arquivamento direto
 ('Em Comissao','Em Comissao'),
 ('Aprovada','Arquivada')
);
