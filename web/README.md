# Aplicação Web — Processo Legislativo CMDC (MVP)

Front-end/back-end do MVP: **Next.js (App Router) + TypeScript + Supabase**.
Implementa o fluxo **registrar → protocolar → tramitar → arquivar** (E1.1–E1.6).

## Arquitetura (resumo)

- **Acesso server-side.** Todo acesso ao banco acontece no servidor (server components e
  *server actions*), usando a chave `service_role`. Por isso a API pública do Supabase permanece
  **travada pelo RLS** — não há chamadas ao banco a partir do navegador.
- **Lógica de domínio** em [`app/actions.ts`](app/actions.ts): numeração automática no protocolo,
  validação de transições da máquina de estados, despacho entre setores, arquivamento e trilha de
  auditoria.

## Telas

| Rota | Função |
|------|--------|
| `/` | Painel com contadores |
| `/proposicoes` | Lista de proposições |
| `/proposicoes/nova` | Registrar rascunho (E1.1) |
| `/proposicoes/[id]` | Detalhe + protocolar/tramitar/despachar/arquivar + linha do tempo |

## Como rodar

```bash
cd web
cp .env.example .env.local     # e preencha a SUPABASE_SERVICE_ROLE_KEY
npm install
npm run dev                    # http://localhost:3000
```

> A **`SUPABASE_SERVICE_ROLE_KEY`** é secreta e fica só no `.env.local` (não versionado).
> Pegue em: painel do Supabase → Project Settings → API → `service_role`.
> Sem ela, o app inicia mas mostra o aviso "Sem conexão com o banco".

## Estado de verificação

- `npm run typecheck` — ✅ sem erros
- `npm run build` — ✅ build de produção ok (5 rotas)
- Runtime — ✅ inicia e renderiza (HTTP 200); degrada graciosamente sem a chave

O teste end-to-end com dados reais exige a `service_role` (segredo do usuário), configurada localmente.

## Próximos passos

- **Autenticação** (Supabase Auth) + **policies de RLS** por papel/órgão (hoje o acesso é via
  service_role no servidor; falta o login dos servidores).
- Caixa de entrada por setor; filtros e busca avançada; notificações (E1.5).
- Validar numeração (reinício anual) e o fluxo de fases com o Regimento Interno.
