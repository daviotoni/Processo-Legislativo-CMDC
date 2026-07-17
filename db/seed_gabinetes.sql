-- =============================================================================
-- Seed: 20a Legislatura (2025-2028) + 29 vereadores e seus gabinetes.
-- Fonte: pagina oficial da CMDC (Vereadores - 20a Legislatura).
-- Executar APOS db/schema.sql. Partido nao consta na fonte (preencher depois).
-- =============================================================================

INSERT INTO legislatura (numero, ano_inicio, ano_fim) VALUES (20, 2025, 2028);

WITH v(sigla, nome, apelido) AS (VALUES
 ('GAB01','Ailton Abreu Nascimento','Chiquinho Caipira'),
 ('GAB02','Alex Freitas Marques','Alex Freitas'),
 ('GAB03','Andreia Almeida Zito dos Santos Hotz','Andreia Zito'),
 ('GAB04','Carlos Alberto de Paula Dias Junior','Junior Uios'),
 ('GAB05','Carlos Augusto Pereira Sodre','Carlinhos da Barreira'),
 ('GAB06','Claudio de Oliveira Thomaz','Claudio Thomaz'),
 ('GAB07','Clovis Mororo Magalhaes','Clovinho Sempre Junto'),
 ('GAB08','Delza Oliveira Sant''Anna de Almeida','Delza de Oliveira'),
 ('GAB09','Divair Alves de Oliveira Junior','Junior Reis'),
 ('GAB10','Eduardo Anderson Goes Lopes','Anderson Lopes'),
 ('GAB11','Eduardo Moreira da Silva','Eduardo Moreira'),
 ('GAB12','Fernanda Izabel da Costa','Fernanda Costa'),
 ('GAB13','Giorgio Carvalho Monteiro','Giorgio Monteiro'),
 ('GAB14','Juliana Fant Alves M. Miranda','Juliana do Taxi'),
 ('GAB15','Leandro da Silva Lourenco','Leandro Enfermeiro'),
 ('GAB16','Marcelo Cardoso Rodrigues','Catiti'),
 ('GAB17','Marcos Fernandes Araujo','Marquinho Oi'),
 ('GAB18','Marcos Oliveira Pereira','Marquinho Dentista'),
 ('GAB19','Marcos Paulo Casal Barbosa','Marquinho da Pipa'),
 ('GAB20','Mauricio Guimaraes Nascimento','Dr. Mauricio'),
 ('GAB21','Michel Reis da Silva','Michel Reis'),
 ('GAB22','Michele Barbosa Perisse Tavares','Michele Tavares'),
 ('GAB23','Moises Luiz Gomes','Moises Neguinho'),
 ('GAB24','Roberto Gabriel de Souza','Beto Gabriel'),
 ('GAB25','Saulo Henrique Silva de Paula','Saulo Henrique'),
 ('GAB26','Sergio Alberto Correa da Rocha','Serginho Correa'),
 ('GAB27','Valdecy Nunes da Rosa Filho','Valdecy Nunes'),
 ('GAB28','Victor Hugo Leonel da Silva','Vitinho Grandao'),
 ('GAB29','Wendell Oliveira Nascimento','Wendell Oliveira')
),
o AS (
  INSERT INTO orgao (nome, sigla, grau)
  SELECT 'Gabinete ' || apelido, sigla, 'GABINETE' FROM v
  RETURNING id, sigla
)
INSERT INTO parlamentar (nome, nome_parlamentar, legislatura_id, gabinete_orgao_id, situacao)
SELECT v.nome, v.apelido,
       (SELECT id FROM legislatura WHERE numero = 20),
       o.id, 'ATIVO'
FROM v JOIN o ON o.sigla = v.sigla;
