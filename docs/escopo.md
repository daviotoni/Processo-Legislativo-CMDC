# Escopo do Projeto — Sistema de Processo Legislativo da CMDC

> Documento de escopo (rascunho para validação). Define o que o sistema é, quem usa e o que
> entra em cada fase. Atualizado conforme as decisões forem sendo confirmadas com os setores.

## 1. Visão do produto

Sistema **oficial** de gestão do processo legislativo da Câmara Municipal de Duque de Caxias,
acompanhando cada proposição/processo **do protocolo até o arquivamento**, com acesso integrado a
**todos os setores** envolvidos na tramitação.

O sistema é o **"prontuário" único** de cada matéria: em qualquer momento deve responder
*onde ela está, com quem, desde quando, o que já aconteceu e o que falta*.

## 2. Foco inicial

**Gestão interna da tramitação.** A prioridade é a operação diária dos servidores e o
acompanhamento pelos gabinetes — não a publicação externa (que vem em fase posterior).

## 3. Usuários

**1ª versão (prioritários):**
- Servidores da **Diretoria de Plenário** (protocolo, apoio ao processo legislativo, apoio às
  comissões, atas, redação legislativa).
- **Vereadores e gabinetes** (autores; acompanham status).

**Fases seguintes:** Mesa Diretora, Comissões (relatores), Consultoria Jurídica, Controladoria,
Diretoria Administrativa (TI/arquivo) e, por fim, o **cidadão** (portal público).

## 4. O ciclo de vida (a espinha dorsal do sistema)

```
PROTOCOLO → Autuação/Numeração → Leitura no Expediente → Distribuição às Comissões
   → Pareceres (constitucionalidade/legalidade/mérito) → Pauta / Ordem do Dia
   → Discussão e Votação (1 ou 2 turnos) → Redação Final → Autógrafo
   → Sanção / Veto (Prefeito) → Promulgação → Publicação → ARQUIVAMENTO
```

**Incidentes de tramitação** que o sistema precisa suportar (não é fluxo linear):
pedido de **vista**, **diligência**, retirada/**adiamento de pauta**, **emendas**, retorno à
comissão, **prejudicialidade**, **desarquivamento**, arquivamento por fim de legislatura.

## 5. MVP — 1ª versão (enxuto)

**Objetivo:** registrar uma proposição e acompanhar toda a sua tramitação interna, com histórico
confiável e controle de acesso por setor.

### Dentro do escopo (MVP)
- Cadastro de proposição: tipo, número/ano, autor(es), ementa, texto e anexos.
- **Protocolo com numeração automática** por tipo/ano.
- **Máquina de estados** de tramitação (do protocolo ao arquivamento).
- Registro de **movimentações/despachos** (data, órgão de origem/destino, responsável, observação).
- **Distribuição às comissões** e registro de **parecer** (mesmo que em formato simples).
- **Situação atual** + **histórico completo** de cada proposição.
- **Busca e consulta** interna de proposições.
- **Perfis e permissões** por setor (quem pode protocolar, despachar, emitir parecer, etc.).
- **Trilha de auditoria** (quem fez o quê e quando) — requisito de sistema oficial.

### Fora do escopo do MVP (fases futuras)
- Votação eletrônica / painel de plenário (cronômetro, tribuna).
- Portal público de transparência e consulta cidadã.
- Assinatura digital e autógrafo eletrônico.
- Integração com Diário Oficial / publicação automática.
- Cálculo de impacto orçamentário-financeiro de proposições.
- Aplicativo mobile.

## 6. Roadmap por fases (visão macro)

| Fase | Entrega | Setores atendidos |
|------|---------|-------------------|
| **1 — MVP** | Proposição + tramitação (protocolo→arquivamento) | Plenário + Gabinetes |
| **2** | Comissões e pareceres estruturados; despachos da Mesa | Comissões + Mesa + Jurídico |
| **3** | Sessões, pauta/ordem do dia e votações | Plenário + Atas |
| **4** | Redação final, autógrafo, publicação e integração D.O. | Redação + Publicação |
| **5** | Portal público de transparência | Cidadão |

## 7. Premissas e requisitos não-funcionais

- **Dados voláteis são configuráveis:** composição da Mesa e comissões mudam por biênio/legislatura;
  tipos de proposição e regras de quórum devem ser parametrizáveis.
- **Sistema oficial** → exige LGPD, trilha de auditoria, e futuramente acessibilidade (e-MAG).
- **Multi-setor** desde a arquitetura → controle de acesso por papel/órgão é requisito central.

## 8. Perguntas em aberto (a validar com os setores)

- Numeração: reinicia a cada ano? por tipo? há legado a importar?
- Quais setores realmente **despacham** vs. apenas **consultam**?
- Como é hoje o registro de parecer das comissões (documento, ata, sistema atual)?
- Existe sistema/legado atual a integrar ou migrar?

> As demandas detalhadas de cada setor estão em [`demandas-por-setor.md`](demandas-por-setor.md).
