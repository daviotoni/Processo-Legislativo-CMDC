# Caminho de Construção — do que faremos, baseado nas atribuições legais

> Este documento traduz as **atribuições de cada setor** (Lei nº 3.525/2025) em um **caminho de
> construção** do sistema. Regra de ouro: *toda funcionalidade rastreia uma atribuição legal de um
> setor*. Assim o sistema apoia exatamente o que a lei manda cada setor fazer.

Referência das atribuições: [`estrutura-cmdc.md`](estrutura-cmdc.md) e a
[Lei nº 3.525/2025](https://www.cmdc.rj.gov.br/?p=30397).

---

## 1. A cadeia processual (a lei já desenha o fluxo)

As atribuições, lidas em conjunto, formam a linha de vida da proposição — do protocolo ao
arquivamento. Cada etapa tem um setor "dono" e uma atribuição que a justifica:

| # | Etapa | Setor "dono" | Atribuição na lei (verbo-chave) |
|---|-------|--------------|--------------------------------|
| 1 | **Elaboração/Redação** | Consultoria-Geral Legislativa; Redação Oficial e Legislativa; Apoio Legislativo | *orientar a redação quanto à técnica normativa* (art. 11); *redigir e revisar / registrar proposições* (art. 35); *assessoria jurídica à redação* (art. 20) |
| 2 | **Protocolo / Autuação** | Coord. da Secretaria-Geral; Apoio Legislativo | *exercer o controle do processo legislativo, observando fases e prazos regimentais* (art. 37); *conferir, digitar, controlar e expedir proposições* (art. 20) |
| 3 | **Distribuição às Comissões / Pareceres** | Assistência às Comissões Permanentes; Consultoria-Geral Legislativa | *elaborar e revisar atas, pareceres e votos* (art. 43); *emitir pareceres técnicos sobre projetos de lei* (art. 11) |
| 4 | **Pauta / Ordem do Dia** | Coord. de Assuntos de Plenário; Diretoria de Plenário | *organizar as pautas; redigir e revisar ordens do dia* (art. 21); *organizar pauta e ordem do dia* (art. 14) |
| 5 | **Sessão / Deliberação / Votação** | Coord. de Assuntos de Plenário; Diretoria de Plenário | *registrar as deliberações do Plenário* (art. 21); *registro fiel e tempestivo das deliberações* (art. 14) |
| 6 | **Atas e presença** | Coord. de Atas e Projetos; Assistência às Comissões | *lavrar e revisar atas; controlar frequência e assinatura dos Vereadores* (art. 22) |
| 7 | **Redação Final / Autógrafo** | Redação Oficial e Legislativa; Secretaria-Geral | *redigir e revisar documentos legislativos* (art. 35); *providenciar o encaminhamento à sanção ou veto* (art. 37) |
| 8 | **Sanção / Veto** | Coord. da Secretaria-Geral | *providenciar o encaminhamento à sanção ou veto; encaminhar atos ao setor de Publicações* (art. 37) |
| 9 | **Publicação** | Coord. de Publicações e Transparência | *coordenar a publicação oficial dos atos normativos* (art. 34) |
| 10 | **Arquivamento / Cadastro de leis** | Coord. da Secretaria-Geral | *organizar arquivo das proposições e pareceres; manter cadastro de leis municipais atualizado* (art. 37) |

**Temas transversais** (aparecem em vários setores → viram funções de base do sistema):
- **Controle de fases e prazos regimentais** — art. 37, art. 20, art. 59. → *máquina de estados + alertas de prazo*.
- **Base de dados legislativa / banco normativo** — art. 14, art. 49, art. 37. → *o próprio sistema é essa base*.
- **Informar Presidente e autores sobre o andamento** — art. 37, art. 35, art. 59. → *consulta de status + notificações*.

---

## 2. Capacidades do sistema derivadas das atribuições

Agrupando as atribuições, o sistema precisa oferecer:

- **Cadastro & Parametrização** — órgãos (4 graus da lei), cargos, usuários/papéis; tipos de
  proposição; **tabela de fases e prazos regimentais**; cadastro de comissões.
- **Redação & Protocolo** — criar proposição (conferir, digitar, formatar), anexos, numeração
  automática, autuação.
- **Controle do Processo Legislativo** — máquina de estados; movimentações/despachos entre setores;
  controle de prazos; verificação de conformidade regimental.
- **Comissões & Pareceres** — distribuição, designação de relator, registro de parecer/voto, arquivo.
- **Plenário** — pauta/ordem do dia, registro de deliberações e votações, presença.
- **Atas** — lavrar/revisar atas de plenário e comissões; certidões; Livro de Posse.
- **Finalização** — redação final, autógrafo, encaminhamento à sanção/veto, promulgação.
- **Publicação & Transparência** — publicação oficial, Boletins Oficiais, Portal da Transparência.
- **Consulta & Relatórios** — andamento por proposição/autor/setor; painéis de prazos.
- **Governança** — perfis/permissões por setor, **trilha de auditoria** (LGPD).

---

## 3. O caminho (sequência de entregas)

Cada fase entrega valor de ponta a ponta para um conjunto de setores. As atribuições dizem a ordem
natural: primeiro **protocolar e controlar** (Secretaria-Geral/Apoio Legislativo), depois
**comissões**, depois **plenário**, depois **publicação**.

### Fase 0 — Fundação (parametrização) 🟢
Base para tudo. Sem isso, nada tramita.
- Cadastro de **órgãos** (os 4 graus da Lei 3.525) e **cargos**.
- **Usuários, papéis e permissões** por setor *(TIC — administração de sistemas)*.
- Cadastro de **tipos de proposição** e da **tabela de fases/prazos regimentais** *(parametrizável)*.
- Cadastro de **comissões** e **legislaturas/biênios**.

### Fase 1 — MVP: Protocolo e Controle do Processo Legislativo 🟢
O coração, atendendo **Secretaria-Geral + Apoio Legislativo + Gabinetes**.
- **Registro de proposição**: autor(es), tipo, ementa, texto, anexos *(art. 20, 35)*.
- **Protocolo/autuação** com numeração automática por tipo/ano *(art. 37)*.
- **Máquina de estados da tramitação** (protocolo → arquivamento) com **controle de fases e prazos
  regimentais** *(art. 37, 20, 59)*.
- **Movimentações/despachos** entre setores, com histórico *(art. 37 — distribuição de documentos)*.
- **Consulta de andamento** + "manter Presidente e autores informados" *(art. 37, 35)*.
- **Arquivamento/desarquivamento** e **cadastro de leis municipais** *(art. 37)*.
- **Permissões por setor** + **trilha de auditoria** *(TIC; Comissão de Proteção de Dados — LGPD)*.

### Fase 2 — Comissões e Pareceres 🟡
Atende **Assistência às Comissões + Consultoria-Geral Legislativa**.
- Distribuição às comissões e designação de **relator** *(art. 43)*.
- Registro de **pareceres e votos**; pedidos de vista/diligência *(art. 43, 11)*.
- Encaminhamento de matérias com parecer "ao Presidente para a ordem do dia" *(art. 20)*.

### Fase 3 — Plenário: Pauta, Sessões e Deliberações 🟡
Atende **Assuntos de Plenário + Diretoria de Plenário + Atas e Projetos**.
- Montagem de **pauta / ordem do dia** *(art. 21, 14)*.
- Registro de **deliberações e votações**; controle de turnos e quórum *(art. 21, 14)*.
- **Atas** de sessão e **presença** dos Vereadores *(art. 22)*.

### Fase 4 — Redação Final, Sanção/Veto e Publicação ⚪
Atende **Redação Oficial + Secretaria-Geral + Publicações e Transparência**.
- **Redação final** e **autógrafo** *(art. 35)*.
- Encaminhamento à **sanção/veto** e controle de prazos *(art. 37)*.
- **Publicação oficial** e Boletins Oficiais *(art. 34, 37)*.

### Fase 5 — Transparência e Cidadão ⚪
Atende **Publicações e Transparência + Ouvidoria-Geral**.
- **Portal da Transparência** e consulta pública *(art. 34)*.
- Atendimento a pedidos de informação (LAI) *(art. 34)*.

---

## 4. Rastreabilidade (funcionalidade → atribuição legal)

Toda entrega deve poder responder *"que atribuição da lei isto atende?"*. As tabelas acima já fazem
esse vínculo. Ao detalhar o backlog, manter a coluna "Artigo/atribuição" em cada item — é o que
garante que o sistema reflete a competência legal de cada setor, e facilita a validação com eles.

## Próximo passo sugerido

Detalhar a **Fase 1 (MVP)** como backlog: para cada épico, escrever as funcionalidades, a regra e a
atribuição de origem — e então **modelar o banco de dados** a partir dele.
