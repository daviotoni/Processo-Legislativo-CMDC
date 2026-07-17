# Sistema de Processo Legislativo — CMDC

Sistema de gestão do **Processo Legislativo da Câmara Municipal de Duque de Caxias (CMDC/RJ)**.

Este repositório está em fase inicial de estruturação. Antes de escrever código, mapeamos a
**estrutura administrativa e o funcionamento legislativo** da Câmara, para que o modelo de dados
e as regras de negócio do sistema reflitam a realidade institucional.

## Documentação de base

| Documento | Conteúdo |
|-----------|----------|
| [`docs/escopo.md`](docs/escopo.md) | **Escopo do projeto**: visão, foco, MVP, roadmap por fases |
| [`docs/visao-plataforma.md`](docs/visao-plataforma.md) | **Visão de plataforma** (norte de longo prazo): macrodomínios, capacidades, acesso RBAC+ABAC |
| [`docs/caminho-construcao.md`](docs/caminho-construcao.md) | **Caminho de construção**: o que faremos, ancorado nas atribuições legais de cada setor |
| [`docs/matriz-legislativa.md`](docs/matriz-legislativa.md) | **Matriz do núcleo legislativo**: setor → atribuição → funcionalidade → perfil → documento → integração |
| [`docs/backlog-mvp.md`](docs/backlog-mvp.md) | **Backlog do MVP** (Fase 0 + 1): épicos, histórias, regras e critérios de aceite |
| [`docs/modelo-dados.md`](docs/modelo-dados.md) | **Modelo de dados**: diagrama, entidades e decisões (esquema em `db/`) |
| [`docs/demandas-por-setor.md`](docs/demandas-por-setor.md) | **Demandas de cada setor** no ciclo de vida da proposição (roteiro de levantamento) |
| [`docs/estrutura-cmdc.md`](docs/estrutura-cmdc.md) | Estrutura administrativa (Mesa Diretora, órgãos assessores, Diretoria-Geral e subordinadas) |
| [`docs/processo-legislativo.md`](docs/processo-legislativo.md) | Poder Legislativo, tipos de proposições, tramitação e comissões |
| [`docs/modelagem-inicial.md`](docs/modelagem-inicial.md) | Primeiras entidades/domínios sugeridos para o sistema |

## Fonte

As informações foram levantadas no site oficial da Câmara: <https://www.cmdc.rj.gov.br>
(consulta em julho/2026). Legislação de referência: Lei Orgânica do Município e Regimento Interno da CMDC.

> ⚠️ Composição de pessoas (Mesa, comissões) e leis específicas mudam a cada legislatura/biênio.
> Trate esses dados como **configuráveis**, nunca fixos no código.
