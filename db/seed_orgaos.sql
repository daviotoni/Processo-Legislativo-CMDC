-- =============================================================================
-- Seed da estrutura de orgaos (E0.1) — Lei 3.525/2025, art. 2o
-- Executar APOS db/schema.sql. Nomes oficiais confirmados na publicacao da CMDC.
-- orgao_pai_id em aberto: linhas de subordinacao dependem da conferencia do
-- Anexo II (organograma) em alta resolucao; o campo `grau` ja organiza os niveis.
-- =============================================================================

INSERT INTO orgao (nome, sigla, grau) VALUES
 -- Comando politico
 ('Presidencia / Mesa Diretora', 'MESA', 'MESA'),
 -- 1o grau: orgaos superiores de direcao e assessoramento tecnico
 ('Consultoria-Geral Legislativa', 'CGL', '1_GRAU'),
 ('Controladoria-Geral', 'CG', '1_GRAU'),
 ('Diretoria da Escola do Legislativo', 'DEL', '1_GRAU'),
 ('Diretoria de Plenario', 'DP', '1_GRAU'),
 ('Diretoria-Geral', 'DG', '1_GRAU'),
 ('Ouvidoria-Geral', 'OG', '1_GRAU'),
 ('Procuradoria-Geral', 'PG', '1_GRAU'),
 ('Superintendencia-Geral', 'SUG', '1_GRAU'),
 ('Superintendencia de Assuntos Estrategicos', 'SAE', '1_GRAU'),
 -- 2o grau: coordenadorias e Diretoria Administrativa
 ('Coordenadoria da Secretaria-Geral', 'CSG', '2_GRAU'),
 ('Coordenadoria de Apoio Legislativo', 'CAL', '2_GRAU'),
 ('Coordenadoria de Redacao Oficial e Legislativa', 'CROL', '2_GRAU'),
 ('Coordenadoria de Assuntos de Plenario', 'CAP', '2_GRAU'),
 ('Coordenadoria de Atas e Projetos', 'CATP', '2_GRAU'),
 ('Coordenadoria de Publicacoes e Transparencia', 'CPT', '2_GRAU'),
 ('Coordenadoria de Cerimonial e Comunicacao Social', 'CCCS', '2_GRAU'),
 ('Coordenadoria de Contabilidade', 'CCONT', '2_GRAU'),
 ('Coordenadoria de Financas', 'CFIN', '2_GRAU'),
 ('Coordenadoria de Licitacoes e Contratos', 'CLC', '2_GRAU'),
 ('Coordenadoria de Avaliacao e Acompanhamento de Compras', 'CAAC', '2_GRAU'),
 ('Coordenadoria de Material', 'CMAT', '2_GRAU'),
 ('Coordenadoria de Patrimonio', 'CPAT', '2_GRAU'),
 ('Coordenadoria de Manutencao', 'CMAN', '2_GRAU'),
 ('Coordenadoria de Recursos Humanos', 'CRH', '2_GRAU'),
 ('Coordenadoria de Tecnologia da Informacao e Comunicacao', 'CTIC', '2_GRAU'),
 ('Coordenadoria de Policia Legislativa', 'CPL', '2_GRAU'),
 ('Coordenadoria de Prevencao a Incendio', 'CPINC', '2_GRAU'),
 ('Coordenadoria de Documentacao Historica', 'CDH', '2_GRAU'),
 ('Diretoria Administrativa', 'DA', '2_GRAU'),
 -- 3o grau: assessoramento parlamentar
 ('Assessoria de Gabinete Parlamentar', 'AGP', '3_GRAU'),
 ('Assessoria Especial da Presidencia', 'AEP', '3_GRAU'),
 ('Assessores Parlamentares', 'AP', '3_GRAU'),
 ('Assistencia as Comissoes Permanentes', 'ACP', '3_GRAU'),
 -- 4o grau: servicos auxiliares
 ('Departamento do e-Social', 'ESOCIAL', '4_GRAU'),
 ('Servicos de Copa', NULL, '4_GRAU'),
 ('Manutencao Predial', NULL, '4_GRAU'),
 ('Telefonia', NULL, '4_GRAU'),
 ('Reprografia', NULL, '4_GRAU'),
 ('Limpeza', NULL, '4_GRAU'),
 ('Transporte', NULL, '4_GRAU'),
 ('Vigilancia Patrimonial', NULL, '4_GRAU'),
 -- Orgaos colegiados de apoio a administracao
 ('Comissao Permanente de Licitacao', 'CPLIC', 'COLEGIADO'),
 ('Comissao Permanente de Recebimento Definitivo de Obras, Servicos e Bens', NULL, 'COLEGIADO'),
 ('Comissao Permanente de Aplicacao de Sancoes', NULL, 'COLEGIADO'),
 ('Comissao Permanente de Protecao de Dados Pessoais', 'CPDP', 'COLEGIADO'),
 ('Comissao Permanente de Atualizacao e Consolidacao de Leis e Normas Municipais', NULL, 'COLEGIADO');
