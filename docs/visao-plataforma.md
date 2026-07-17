# Visão de Plataforma (Norte de longo prazo)

> Este documento captura a **visão ampla** do sistema, derivada de um estudo analítico da
> Lei 3.525/2025 (relatório assistido por IA, encomendado pelo cliente). Serve como **norte** —
> não como escopo imediato. O escopo que vamos construir primeiro continua sendo o do
> [`escopo.md`](escopo.md) e [`backlog-mvp.md`](backlog-mvp.md).
>
> **⚠️ Sobre confiabilidade:** o estudo é rico, mas foi gerado por IA e traz citações não
> auditáveis. Os itens abaixo estão marcados como ✅ verificado na lei oficial, ou ⚠️ a validar.

## 1. Enquadramento normativo

- ✅ **Lei nº 3.525/2025**, oriunda do **PL nº 044/2025**, autor **Mesa Diretora**; ementa:
  *"Dispõe sobre a organização administrativa da CMDC e dá outras providências"*.
- ✅ Prevê **cargos em comissão** (Anexo I; provimento por Portaria do Presidente — art. 3º) e
  **funções gratificadas** (art. 5º).
- ✅ **Gabinetes parlamentares** podem atuar em regime **externo, remoto, em escalas e fora do
  horário** (art. 3º, §3º) → o sistema precisa suportar acesso remoto e delegação.
- ✅ **Controlador-Geral é privativo de servidor efetivo** (art. 51, § único) → regra de
  **elegibilidade por vínculo** (já modelada: `papel.exige_vinculo_efetivo`).
- ✅ **Anexo I** (denominação, símbolo, retribuição e quantitativo) **confirmado na publicação
  oficial da CMDC**: **49 espécies de cargos/funções**, totalizando **615 postos**. Maiores
  quantitativos: 96 Assessores Parlamentares I, 96 Assessores Parlamentares II, 90 Assistentes de
  Gabinete I, 70 Assessores Parlamentares III e 70 Assistentes de Gabinete II.
- ✅ **Hierarquia da Casa (art. 2º)** confirmada: 1º grau (órgãos superiores), 2º grau
  (coordenadorias + Diretoria Administrativa), 3º grau (assessoramento parlamentar), 4º grau
  (serviços auxiliares).
- ⚠️ **Anexo II (organograma)**: existe como **imagem** vinculada à página, mas ainda **pendente de
  conferência em alta resolução** para validar graficamente as linhas de subordinação. Não bloqueia
  o projeto — os nomes (art. 2º), atribuições (arts. 11–48 e 49–98) e quantitativos (Anexo I) já
  estão disponíveis no texto legal.
- ⚠️ **Efeitos financeiros a partir de 01/09/2025**: citado no estudo, ainda a confirmar no texto.

> Implicação de produto: o cadastro organizacional deve ser **parametrizado pelo Anexo I**
> (dado, não código), pois a lei permite remanejamentos futuros por resolução. Os 615 postos e as
> 49 espécies servem de base para o **motor de lotação** e para o dimensionamento de perfis.

## 2. Quatro macrodomínios de negócio

1. **Legislativo** — Consultoria-Geral Legislativa, Diretoria de Plenário, Apoio Legislativo,
   Assuntos de Plenário, Atas e Projetos, Redação Oficial, Secretaria-Geral, gabinetes e comissões.
   *(É onde nosso MVP atua.)*
2. **Administrativo-financeiro** — Diretoria-Geral, Superintendências, Controladoria, Compras,
   Licitações e Contratos, Contabilidade, Finanças, RH, Material, Patrimônio, Manutenção, TI, e-Social.
3. **Público-institucional** — Ouvidoria, Publicações e Transparência, Cerimonial e Comunicação,
   Escola do Legislativo, Documentação Histórica.
4. **Integridade, segurança e contencioso** — Procuradoria-Geral, Polícia Legislativa, Prevenção a
   Incêndio, Comissão de Proteção de Dados (LGPD), Comissão de Aplicação de Sanções.

## 3. Oito capacidades estruturantes (a plataforma completa)

1. Identidade, lotação e delegações
2. Protocolo e expediente
3. Processo legislativo
4. Plenário: pauta, sessão e votação
5. Comissões
6. Jurídico (contencioso e consultivo)
7. Administração interna e contratações
8. Transparência, ouvidoria, LAI e LGPD

Sobre uma **camada compartilhada**: cadastro organizacional, pessoas/cargos/lotação, delegações,
assinatura eletrônica, gestão documental + versionamento, logs de auditoria, classificação de
sigilo, notificações, agenda, busca unificada e **motor de workflow**. Sem essa camada, a Casa
recria "ilhas de sistema".

## 4. Modelo de acesso: RBAC + ABAC (5 dimensões)

O estudo acertou num ponto que já incorporamos ao modelo de dados: a permissão final resulta da
combinação de cinco dimensões, não de um "perfil fixo":

| Dimensão | Onde está no modelo |
|----------|---------------------|
| **Lotação formal** | `usuario.orgao_id` |
| **Cargo/função** | `usuario.cargo_id`, `usuario.vinculo` |
| **Papel processual** | `papel` / `usuario_papel` |
| **Delegação/substituição** | `delegacao` (com ato formal e prazo) |
| **Nível de sigilo** | `*.nivel_sigilo` |

**Níveis de sigilo** (4): `PUBLICO`, `INTERNO`, `RESTRITO_FUNCIONAL`, `RESTRITO_SENSIVEL`.
Regra geral: proposições, atas e deliberações nascem **públicas** (salvo exceção legal); RH,
e-Social, jurídico, ouvidoria/denúncias e dados pessoais nascem **restritos**. Conciliar LAI
(transparência) com LGPD (proteção de dados).

## 5. IA assistiva (não decisória)

A IA pode **classificar, sugerir, resumir, checar (LC 95), transcrever e minutar** — mas
**decisão, assinatura, classificação de sigilo, publicação e deliberação permanecem humanas**.
Recomenda-se um **painel de governança de IA** (catálogo de usos, registro por processo, base
documental utilizada, aprovador humano). *(Fase futura; fora do MVP.)*

## 6. Mapa de módulos e prioridade (resumo do estudo)

Alta prioridade (operação diária + risco regimental/jurídico): **Legislativo** (protocolo,
proposições, pauta/sessão/votação, comissões, gabinetes), **Procuradoria**, **Transparência/LAI/LGPD**,
**RH/e-Social**, **Contabilidade/Finanças**, **Licitações/Contratos**.
Média: Material/Patrimônio/Manutenção, Segurança/Incêndio, Cerimonial, Escola, Documentação
Histórica, Assuntos Estratégicos. Baixa: serviços auxiliares (copa, transporte, etc.).

> O detalhamento órgão→atribuição→funcionalidade está no estudo original (PDF em anexo à conversa).
> A parte **legislativa de alta prioridade** já está destrinchada no nosso
> [`caminho-construcao.md`](caminho-construcao.md) e [`backlog-mvp.md`](backlog-mvp.md).

## 7. Como isto muda (ou não) o nosso plano

- **Não muda o MVP:** continuamos por protocolo + tramitação legislativa (fatia de maior retorno e
  já validada pelo estudo como "Alta prioridade").
- **Muda o modelo de acesso:** adotamos **RBAC + ABAC + sigilo + delegação + vínculo** desde já
  (feito no [`schema.sql`](../db/schema.sql)), porque é caro retrofitar.
- **Reforça requisitos:** auditoria imutável, cadeia de custódia (hash de anexos), LGPD.
- **Roadmap pós-MVP:** os demais domínios (jurídico, administrativo-financeiro, transparência)
  entram nas fases seguintes, reusando a camada compartilhada.

## 8. Situação da validação (atualizado)

A estrutura administrativa, os cargos, as funções e os quantitativos da Lei nº 3.525/2025 **já foram
identificados na publicação oficial da CMDC**. Permanece pendente apenas:

- ⚠️ **Conferência visual do Anexo II em alta resolução** — para validar graficamente as relações de
  subordinação do organograma (sem prejuízo do mapeamento funcional, que já é possível pelo texto
  legal: nomes no art. 2º, atribuições dos órgãos nos arts. 11–48, atribuições dos cargos nos
  arts. 49–98 e quantitativos no Anexo I).
- ⚠️ Cláusula de **vigência e efeitos financeiros** (confirmar no texto/Boletim nº 7632).

> Conclusão: **não é preciso aguardar o PDF** para elaborar a matriz
> *setor → atribuição legal → funcionalidade → perfil → documento → integração*. A única lacuna é
> gráfica (linhas de subordinação do Anexo II).
