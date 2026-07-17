# Estrutura Administrativa — Câmara Municipal de Duque de Caxias (CMDC)

Fonte: [site oficial da CMDC](https://www.cmdc.rj.gov.br/?page_id=6) e organograma institucional
(consulta em julho/2026). Composição do biênio 2025/2027.

## 1. Mesa Diretora

Órgão colegiado de direção, composto por **5 membros** eleitos pelos vereadores para mandato de
2 anos (biênio). É responsável pela direção dos trabalhos legislativos e pela administração interna
da Câmara.

| Cargo | Função principal |
|-------|------------------|
| Presidente | Preside as sessões plenárias e representa a Câmara |
| 1º Vice-Presidente | Substitui o Presidente |
| 2º Vice-Presidente | Substitui na ausência do 1º Vice |
| 1º Secretário | Expediente, atas e correspondência oficial |
| 2º Secretário | Auxilia o 1º Secretário |

## 2. Órgãos Assessores da Mesa Diretora

Ligados diretamente à Mesa Diretora:

- **Defensoria do Povo** — canal de comunicação entre a sociedade e a Câmara (ouvidoria).
- **Controladoria-Geral** — controle interno.
- **Consultoria-Geral Jurídica / Procuradoria-Geral** — assessoramento jurídico.
- **Coordenadoria de Segurança Legislativa** — segurança dos trabalhos legislativos.
- **Coordenadoria Militar** — apoio de segurança.

## 3. Diretoria-Geral

Órgão executivo máximo da administração da Câmara. Coordena as diretorias e coordenadorias abaixo.

### 3.1 Diretoria de Orçamento, Finanças e Contabilidade
- Coordenadoria de Planejamento e Execução Orçamentária
- Coordenadoria de Contabilidade
- Coordenadoria de Finanças / Tesouraria

### 3.2 Diretoria de Plenário
- Coordenadoria de Apoio ao Processo Legislativo
- Coordenadoria de Apoio às Comissões
- Coordenadoria de Atas e Projetos
- Coordenadoria de Redação Legislativa

### 3.3 Diretoria de Administração
- Coordenadoria de Expediente, Protocolo e Arquivo
- Coordenadoria de Processamento de Dados e Suporte de Informática (TI)
- Coordenadoria de Almoxarifado / Material
- Coordenadoria de Patrimônio
- Coordenadoria de Manutenção e Serviços Gerais
- Coordenadoria de Recursos Humanos
- Coordenadoria de Licitação e Contratos
- Coordenadoria de Avaliação e Acompanhamento de Compras (CAACs)
- Coordenadoria de Documentação Histórica

## 4. Gabinetes dos Vereadores

**29 vereadores** (parlamentares), cada um com gabinete próprio. A composição muda a cada
legislatura (4 anos).

## Organograma resumido

```
                          PLENÁRIO (29 vereadores)
                                  │
                            MESA DIRETORA
                    (Presidente + 2 Vices + 2 Secretários)
                                  │
        ┌─────────────────────────┼──────────────────────────┐
        │                         │                          │
  Órgãos Assessores         DIRETORIA-GERAL             Gabinetes
  - Defensoria do Povo             │                    (29 gabinetes)
  - Controladoria-Geral            │
  - Consultoria Jurídica    ┌──────┼──────────────┐
  - Seg. Legislativa        │      │              │
  - Coord. Militar     Dir. Orçam.  Dir.       Dir.
                       Fin. Contab. Plenário   Administração
```

## Implicações para o sistema

- A **hierarquia de órgãos** (Mesa → Diretorias → Coordenadorias) é razoavelmente estável e serve
  de base para controle de **perfis/permissões** e roteamento de tramitação.
- A **Diretoria de Plenário** (Apoio ao Processo Legislativo, Apoio às Comissões, Atas, Redação
  Legislativa) é a área que o sistema mais impacta no dia a dia.
- Cargos e nomes de pessoas são **voláteis** (mudam por biênio/legislatura) → devem ser dados de
  configuração, não constantes de código.
