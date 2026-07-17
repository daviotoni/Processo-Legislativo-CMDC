# Matriz do Núcleo Legislativo

> Matriz **setor → atribuição legal → funcionalidade → perfil → documento → integração** para o
> domínio **Legislativo** (o núcleo do MVP). Base: Lei 3.525/2025 (arts. citados) +
> [`caminho-construcao.md`](caminho-construcao.md). Perfis referenciam os papéis do sistema
> (ver [`modelo-dados.md`](modelo-dados.md)); alguns marcados *(fase 2+)* ainda serão criados.

## Como ler os "perfis"

O perfil efetivo é a combinação **lotação + cargo/vínculo + papel + delegação + sigilo** (RBAC+ABAC).
Aqui a coluna "Perfil" indica o **papel** predominante da ação.

## Matriz

| Setor (órgão) | Atribuição legal | Funcionalidade do sistema | Perfil | Documento | Integração |
|---|---|---|---|---|---|
| **Coord. da Secretaria-Geral** | *Controle do processo legislativo; organizar arquivo de proposições e pareceres; encaminhar à sanção/veto* (art. 37) | Protocolo/autuação; numeração automática; painel de situação; arquivamento/desarquivamento; cadastro de leis | `PROTOCOLO` | Proposição autuada; Lei; Boletim Oficial | Storage (anexos); Publicações (fase 4); notificações |
| **Coord. de Apoio Legislativo** | *Conferir, digitar, controlar e expedir proposições; controle de fases e prazos; encaminhar à ordem do dia* (art. 20) | Editor de proposição; checklist regimental; workflow de tramitação; controle de prazos | `AUTOR_GABINETE` / `TRAMITACAO` | Proposição; despacho | Máquina de estados (`fase`/`transicao`) |
| **Coord. de Redação Oficial e Legislativa** | *Redigir/revisar documentos legislativos; registrar proposições; guardar via* (art. 35) | Modelos por espécie; revisão/redação final; registro de proposições | `REDATOR` *(fase 2+)* | Redação final; autógrafo | Versionamento de texto |
| **Coord. de Assuntos de Plenário** | *Organizar pautas; redigir ordens do dia; registrar deliberações* (art. 21) | Pauta / ordem do dia; registro de deliberações | `OPERADOR_SESSAO` *(fase 3)* | Ordem do dia; pauta | Sessões e votações (fase 3) |
| **Coord. de Atas e Projetos** | *Lavrar/revisar atas; controlar presença; Livro de Posse* (art. 22) | Ata eletrônica; presença; certidões de posse | `SEC_ATA` *(fase 3)* | Ata; certidão; Livro de Posse | Áudio/vídeo da sessão (futuro) |
| **Diretoria de Plenário** | *Coordenar apoio às sessões; base de dados legislativa; registro das deliberações* (arts. 14/53) | Cockpit de sessão; consolidação de pauta; base legislativa | `OPERADOR_SESSAO` *(fase 3)* | Roteiro de sessão; resultado | Painel de plenário; audiovisual |
| **Assistência às Comissões Permanentes** | *Apoio às comissões; elaborar/revisar pareceres e votos; organizar processos* (art. 43) | Distribuição ao relator; parecer; diligência; histórico da comissão | `RELATOR_COMISSAO` *(fase 2)* | Parecer; voto; ata de comissão | Fila de comissões |
| **Consultoria-Geral Legislativa** | *Pareceres técnicos; técnica normativa; banco normativo* (arts. 11/49) | Parecer técnico; checklist LC 95; pesquisa normativa | `CONSULTOR` *(fase 2)* | Parecer técnico; nota | Banco de leis |
| **Coord. de Publicações e Transparência** | *Publicação oficial dos atos; Portal da Transparência; LAI* (art. 34) | Barramento de publicação; dados abertos; pedidos LAI | `PUBLICADOR` *(fase 4/5)* | Ato publicado; Boletim Oficial | Portal público; Diário Oficial |
| **Gabinetes Parlamentares** (×29) / Assessoria de Gabinete | *Apoio ao Vereador; elaboração de proposições; acompanhamento* (arts. 40/79) | Registro de proposição (rascunho); acompanhamento de status; emendas | `AUTOR_GABINETE` | Proposição (rascunho); emenda | Notificações; consulta |
| **Presidência / Mesa Diretora** | *Direção dos trabalhos; despachos e decisões* | Despachos; deferimento de requerimentos; painel gerencial | `MESA` *(fase 2)* | Despacho; decisão | Trilha de auditoria |

## Recorte do MVP (o que entra na Fase 1)

Do quadro acima, o **MVP** cobre as linhas com perfil `PROTOCOLO`, `AUTOR_GABINETE` e `TRAMITACAO`:

- **Gabinetes** registram proposição (rascunho) → **Secretaria-Geral** protocola/autua →
  **Apoio Legislativo** controla a tramitação (fases/prazos/despachos) → **Secretaria-Geral**
  arquiva e mantém o cadastro de leis.

As demais linhas (Redação, Plenário, Atas, Comissões, Consultoria, Publicações, Mesa) já estão
mapeadas e entram nas **fases 2–5**, reusando as mesmas entidades.

## Os 29 gabinetes

Os 29 gabinetes são **instâncias do mesmo perfil** (`AUTOR_GABINETE`): no banco são 29 registros em
`orgao` (grau `GABINETE`), cada um vinculável a um `parlamentar`. Já cadastrados no ambiente
(`Gabinete Parlamentar 01`…`29`) — os nomes definitivos entram quando a composição da 20ª
Legislatura for cadastrada. Escala sem mudar o modelo.

## Perfis a criar nas próximas fases

`REDATOR`, `OPERADOR_SESSAO`, `SEC_ATA`, `RELATOR_COMISSAO`, `CONSULTOR`, `PUBLICADOR`, `MESA` —
todos encaixam no modelo `papel`/`usuario_papel` sem alteração de esquema.
