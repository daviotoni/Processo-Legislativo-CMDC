-- =============================================================================
-- Seed: 20a Legislatura + 29 gabinetes parlamentares (grau GABINETE).
-- Executar APOS db/schema.sql. Nomes definitivos dos gabinetes serao vinculados
-- aos vereadores quando a composicao da legislatura for cadastrada.
-- =============================================================================

INSERT INTO legislatura (numero, ano_inicio, ano_fim) VALUES (20, 2025, 2028);

INSERT INTO orgao (nome, sigla, grau)
SELECT 'Gabinete Parlamentar ' || lpad(g::text, 2, '0'),
       'GAB' || lpad(g::text, 2, '0'),
       'GABINETE'
FROM generate_series(1, 29) AS g;
