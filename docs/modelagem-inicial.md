# Modelagem Inicial — Sistema de Processo Legislativo

Proposta de **domínios e entidades** derivada da estrutura da CMDC. É um ponto de partida para
discussão, não um esquema definitivo.

## Domínios

1. **Pessoas & Órgãos** — vereadores, servidores, Mesa Diretora, diretorias/coordenadorias, comissões.
2. **Proposições** — o material legislativo em si e sua autoria.
3. **Tramitação** — o ciclo de vida (máquina de estados) de cada proposição.
4. **Sessões & Votações** — pauta, deliberação e registro de votos.
5. **Publicação & Legislação** — leis promulgadas, atos e acervo normativo.

## Entidades principais (esboço)

### Parlamentar (Vereador)
- nome, partido, legislatura, gabinete, situação (ativo/licenciado/suplente)

### Órgão
- nome, tipo (`MESA` | `DIRETORIA` | `COORDENADORIA` | `COMISSAO` | `GABINETE` | `ORGAO_ASSESSOR`)
- órgão pai (auto-relacionamento p/ hierarquia)

### Comissão
- órgão (é um tipo de órgão), classe (`PERMANENTE` | `TEMPORARIA`), biênio
- membros: parlamentar + papel (`PRESIDENTE` | `VICE` | `RELATOR` | `SUPLENTE_1` | `SUPLENTE_2`)

### Proposição
- tipo (`EMENDA_LOM` | `LEI_COMPLEMENTAR` | `LEI_ORDINARIA` | `LEI_DELEGADA` |
  `MEDIDA_PROVISORIA` | `DECRETO_LEGISLATIVO` | `RESOLUCAO` | `INDICACAO` | `REQUERIMENTO` |
  `MOCAO` | `EMENDA`)
- número, ano, ementa, texto, autor(es), data de protocolo, status atual

### TramitacaoEvento
- proposição, data, órgão de destino, situação, parecer (opcional), responsável

### Sessao
- tipo (`ORDINARIA` | `EXTRAORDINARIA` | `SOLENE`), data, legislatura, pauta

### Votacao
- sessão, proposição, turno, quórum exigido, resultado (`APROVADA` | `REJEITADA`)
- votos: parlamentar + voto (`SIM` | `NAO` | `ABSTENCAO` | `AUSENTE`)

## Regras de negócio que já sabemos

- **Quórum depende do tipo de proposição** (ex.: Emenda à LOM = 2/3 em 2 turnos; Lei Complementar
  = maioria absoluta; Lei Ordinária = maioria simples). → tabela de regras por tipo.
- Nem toda proposição vai à **sanção do Prefeito** (resoluções e decretos legislativos não vão).
- **Redação Final** passa pela Comissão de Legislação, Justiça e Redação Final.
- Composições (Mesa, comissões) são **temporais** (por biênio/legislatura) → versionar por período.

## Próximos passos sugeridos

1. Validar os tipos de proposição e o fluxo com o Regimento Interno da CMDC.
2. Escolher a stack (o ambiente já tem Supabase/Postgres disponível — bom candidato).
3. Modelar o esquema do banco a partir das entidades acima.
4. Priorizar o MVP: cadastro de proposição + tramitação + consulta pública.
