# Backlog do MVP (Fase 0 + Fase 1)

> Detalhamento das entregas do [`caminho-construcao.md`](caminho-construcao.md). Cada item traz a
> **atribuição legal de origem** (Lei nº 3.525/2025). Formato: história do usuário → regras de
> negócio → artigo de origem → critérios de aceite.
>
> Legenda de prioridade (MoSCoW): **M** Must · **S** Should · **C** Could.

---

## FASE 0 — Fundação (parametrização)

Sem esta base nada tramita. É pré-requisito da Fase 1.

### E0.1 — Cadastro de Órgãos `M`
> Como **admin (TIC)**, quero cadastrar os órgãos da Câmara com sua hierarquia, para refletir a
> estrutura da Lei 3.525/2025 e rotear a tramitação.

- **Regras:** órgão tem `nome`, `sigla`, `grau` (1º–4º / colegiado / gabinete) e `órgão-pai`
  (auto-relacionamento). Órgão pode ser marcado como **ativo/inativo** (não excluído, para preservar
  histórico).
- **Origem:** estrutura administrativa da Lei 3.525/2025 (arts. 8º e seguintes).
- **Aceite:** consigo cadastrar os 4 graus e visualizar a árvore; um órgão inativo não aparece para
  novos encaminhamentos, mas permanece no histórico.

### E0.2 — Cadastro de Cargos `S`
> Como **admin**, quero cadastrar os cargos (Diretor-Geral, Diretor, Coordenador, Assessor,
> Secretário…) vinculados a órgãos.

- **Regras:** cargo pertence a um órgão; usado para identificar responsáveis por despachos.
- **Origem:** arts. 49, 53, 54, 59 (atribuições de cargos).
- **Aceite:** cargo cadastrado aparece na atribuição de um usuário.

### E0.3 — Usuários, Papéis e Permissões `M`
> Como **admin (TIC)**, quero cadastrar usuários e conceder papéis por setor, para que cada um faça
> só o que sua competência permite.

- **Regras:** usuário pertence a um órgão e tem um ou mais **papéis** (ex.: `PROTOCOLO`,
  `TRAMITACAO`, `AUTOR_GABINETE`, `CONSULTA`, `ADMIN`). Permissão é por **ação** (protocolar,
  despachar, arquivar, consultar). Autenticação com senha; sessão expira.
- **Origem:** TIC — *"administração de sistemas e bases de dados; suporte aos usuários"*.
- **Aceite:** um usuário só-consulta não consegue protocolar; toda ação registra o autor.

### E0.4 — Tipos de Proposição `M`
> Como **admin**, quero parametrizar os tipos de proposição, porque as regras variam por tipo.

- **Regras:** cada tipo tem `nome`, `sigla` (ex.: PL, PLC, PEC-LOM, PR, PDL, IND, REQ, MOC),
  `exige_sanção` (sim/não), `turnos` (1/2) e `quórum` (referência de regra). Configurável, não fixo
  no código.
- **Origem:** processo legislativo municipal (ver [`processo-legislativo.md`](processo-legislativo.md)).
- **Aceite:** ao criar uma proposição, escolho o tipo e o sistema aplica suas regras.

### E0.5 — Fases e Prazos Regimentais (workflow) `M`
> Como **admin**, quero configurar as fases da tramitação e seus prazos, para o sistema controlar o
> "observando as fases e prazos regimentais".

- **Regras:** uma **fase** tem `nome`, `ordem`, `órgão responsável padrão` e `prazo (dias)`
  opcional. As transições permitidas entre fases são configuráveis (máquina de estados
  parametrizável). Pode haver mais de um fluxo por tipo de proposição.
- **Origem:** art. 37, art. 20, art. 59 — *"exercer o controle do processo legislativo, observando
  as fases e prazos regimentais"*.
- **Aceite:** consigo definir um fluxo (ex.: Protocolada → Distribuição → … → Arquivada) e o sistema
  só permite transições previstas.

### E0.6 — Legislaturas, Biênios, Comissões e Vereadores `S`
> Como **admin**, quero cadastrar legislaturas/biênios, vereadores e comissões, porque essas
> composições mudam no tempo.

- **Regras:** composições são **temporais** (vinculadas a um período). Vereador tem situação
  (ativo/licenciado/suplente). Comissão permanente tem 5 papéis (Presidente, Vice, Relator, 2
  Suplentes) por biênio.
- **Origem:** estrutura das comissões (ver [`processo-legislativo.md`](processo-legislativo.md));
  art. 22 (Livro de Posse).
- **Aceite:** a composição de uma comissão de um biênio anterior é preservada ao iniciar novo biênio.

---

## FASE 1 — MVP: Protocolo e Controle do Processo Legislativo

Atende **Secretaria-Geral + Apoio Legislativo + Gabinetes**. Objetivo: registrar uma proposição e
acompanhar toda a sua tramitação interna, com histórico confiável.

### E1.1 — Registro/Redação de Proposição `M`
> Como **gabinete/assessor autor**, quero registrar uma proposição (rascunho) com seus dados e
> anexos, para submetê-la ao protocolo.

- **Regras:**
  - Campos: `tipo`, `autor(es)` (com coautoria/subscrição), `ementa`, `texto`, `anexos`.
  - Estado inicial **Rascunho** (ainda sem número oficial).
  - Validação básica de técnica legislativa/documentação exigida (checklist).
- **Origem:** art. 20 *("conferir, digitar, controlar e expedir proposições")*; art. 35
  *("redigir e revisar… registrar proposições conforme normas regimentais")*.
- **Aceite:** salvo um rascunho com anexo; enquanto Rascunho, o autor pode editar; sem número de
  protocolo ainda.

### E1.2 — Protocolo e Autuação (numeração automática) `M`
> Como **servidor da Secretaria-Geral**, quero protocolar uma proposição, atribuindo número oficial
> e autuando o processo.

- **Regras:**
  - Numeração **automática por tipo e ano** (ex.: PL 001/2026). *(Reinício anual — a confirmar com
    a Secretaria-Geral.)*
  - Ao protocolar: estado passa a **Protocolada**, data/hora registradas, autor do protocolo
    gravado; a partir daí o autor **não edita** o texto (só por emenda/despacho).
  - Gera o **processo** (contêiner) que acompanhará a matéria até o arquivamento.
- **Origem:** art. 37 *("exercer o controle do processo legislativo… organizar arquivo das
  proposições")*.
- **Aceite:** proposição protocolada recebe número único sequencial; não é possível protocolar duas
  vezes; número não se repete no mesmo tipo/ano.

### E1.3 — Máquina de Estados da Tramitação + Controle de Prazos `M`
> Como **servidor**, quero mover a proposição pelas fases regimentais, para o sistema saber sempre
> onde ela está e se há prazo vencendo.

- **Regras:**
  - A proposição sempre tem **uma situação atual** (fase) e um **órgão atual**.
  - Só são permitidas as **transições configuradas** (E0.5).
  - Cada transição grava um **evento** (fase origem/destino, data, responsável, observação).
  - **Prazos:** ao entrar numa fase com prazo, o sistema calcula o vencimento e sinaliza
    **atrasados/a vencer**.
  - Incidentes suportados (registráveis): **vista, diligência, adiamento/retirada de pauta,
    prejudicialidade, desarquivamento**.
- **Origem:** art. 37, art. 20, art. 59 *("observando as fases e prazos regimentais")*.
- **Aceite:** não consigo pular uma transição não prevista; ao vencer um prazo a matéria aparece na
  lista de "prazos vencidos"; o histórico mostra toda a trajetória.

### E1.4 — Movimentações / Despachos entre Setores `M`
> Como **servidor**, quero encaminhar (despachar) a proposição a outro setor com uma observação,
> para dar andamento e manter o rastro.

- **Regras:** despacho tem `órgão de origem`, `órgão de destino`, `responsável`, `data`, `texto`.
  Registrar despacho move o **órgão atual**. Todo despacho entra no histórico.
- **Origem:** art. 37 *("executar e controlar a distribuição de correspondências e documentos")*;
  art. 20 *("encaminhar documentos legislativos à Diretoria-Geral para registro e arquivamento")*.
- **Aceite:** ao despachar, o setor de destino passa a ver a matéria em sua caixa de entrada; o
  histórico registra quem despachou, para onde e quando.

### E1.5 — Consulta de Andamento e Notificações `M`(consulta) / `S`(notificações)
> Como **autor/Presidente**, quero consultar o andamento e ser avisado de mudanças, para acompanhar
> a matéria sem precisar perguntar.

- **Regras:**
  - Busca por número, tipo, autor, ementa, situação, período.
  - **Ficha da proposição**: dados + situação atual + linha do tempo (histórico).
  - Notificação (in-app/e-mail) ao autor quando a situação muda. *(Should — pode entrar no fim da
    Fase 1.)*
- **Origem:** art. 37 *("manter o Presidente informado sobre as proposições em trâmite")*; art. 35
  *("prestar informações sobre o andamento de proposições aos autores")*.
- **Aceite:** localizo uma proposição por qualquer critério e vejo sua linha do tempo; ao mudar a
  situação, o autor é notificado.

### E1.6 — Arquivamento, Desarquivamento e Cadastro de Leis `M`
> Como **servidor da Secretaria-Geral**, quero arquivar/desarquivar processos e manter o cadastro
> das leis municipais, para encerrar o ciclo e manter a base normativa.

- **Regras:**
  - **Arquivamento** com motivo (ex.: aprovada e publicada, rejeitada, fim de legislatura).
  - **Desarquivamento** registra novo evento e reabre a tramitação.
  - Ao final favorável, gera/atualiza o **cadastro de leis municipais** (nº da lei, data, ementa,
    link ao processo de origem).
- **Origem:** art. 37 *("organizar arquivo das proposições e pareceres; manter cadastro de leis
  municipais atualizado")*.
- **Aceite:** processo arquivado sai das caixas de trabalho mas continua consultável; ao
  desarquivar, volta à tramitação com registro; lei publicada aparece no cadastro de leis.

### E1.7 — Permissões por Setor e Trilha de Auditoria `M`
> Como **Controladoria/TIC**, quero que toda ação relevante fique registrada e restrita por
> competência, para garantir segurança e conformidade.

- **Regras:**
  - Cada ação (protocolar, despachar, arquivar, editar cadastro) exige permissão do papel (E0.3).
  - **Trilha de auditoria**: log imutável de quem fez o quê, quando e de onde (dados anteriores/novos).
  - Requisitos de **LGPD** para dados pessoais (base legal, retenção, acesso restrito).
- **Origem:** TIC (administração/segurança); **Comissão Permanente de Proteção de Dados Pessoais**
  (LGPD); Controladoria-Geral (controle interno).
- **Aceite:** ação sem permissão é bloqueada e registrada; a trilha mostra o histórico de alterações
  de um registro.

---

## Requisitos não-funcionais (valem para todo o MVP)

- **Segurança/LGPD:** controle de acesso por papel; trilha de auditoria; dados pessoais protegidos.
- **Confiabilidade:** histórico **imutável** (eventos não se apagam; correções geram novo evento).
- **Usabilidade:** foco em quem opera o dia a dia (Secretaria-Geral e gabinetes).
- **Parametrização:** tipos, fases, prazos, órgãos e composições **configuráveis** (sem depender de
  time de TI para mudanças de biênio/regimento).
- **Disponibilidade/backup:** rotina de backup (responsabilidade de TIC).

## Definição de Pronto (DoD)

Um item está pronto quando: atende aos critérios de aceite; respeita permissões; registra trilha de
auditoria; foi validado com o setor "dono" da atribuição; e tem a origem legal referenciada.

## Fora do MVP (lembrete)

Votação eletrônica, pauta/ordem do dia estruturada, pareceres de comissão estruturados, redação
final/autógrafo, publicação/D.O., portal público — **fases 2 a 5**.

## Próximo passo

Modelar o **banco de dados** a partir deste backlog: entidades `Orgao`, `Cargo`, `Usuario`,
`Papel`, `TipoProposicao`, `Fase`, `Transicao`, `Proposicao`, `Processo`, `EventoTramitacao`,
`Despacho`, `Lei`, `LogAuditoria` — ver esboço em [`modelagem-inicial.md`](modelagem-inicial.md).
