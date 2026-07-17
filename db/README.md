# Banco de dados

Esquema e dados iniciais do MVP (PostgreSQL / Supabase).

## Arquivos (ordem de execução)

1. [`schema.sql`](schema.sql) — DDL do MVP (Fase 0 + Fase 1).
2. [`seed.sql`](seed.sql) — tipos de proposição, papéis, permissões, fases, transições, mapa papel→permissão.
3. [`seed_orgaos.sql`](seed_orgaos.sql) — estrutura de órgãos (Lei 3.525/2025, art. 2º).
4. [`seed_gabinetes.sql`](seed_gabinetes.sql) — 20ª Legislatura + 29 gabinetes parlamentares.
5. [`rls.sql`](rls.sql) — habilita RLS em todas as tabelas (padrão seguro).

```bash
psql "$DATABASE_URL" -f db/schema.sql
psql "$DATABASE_URL" -f db/seed.sql
psql "$DATABASE_URL" -f db/seed_orgaos.sql
psql "$DATABASE_URL" -f db/seed_gabinetes.sql
psql "$DATABASE_URL" -f db/rls.sql
```

## Ambiente provisionado (Supabase)

- **Projeto:** `processo-legislativo-cmdc` · **ref:** `yqnthodhudvzkhagozbb` · **região:** `sa-east-1` (São Paulo)
- **URL:** `https://yqnthodhudvzkhagozbb.supabase.co`
- Estado atual: schema aplicado (migrations `mvp_schema_fase0_fase1` + `enable_rls_all_tables`) +
  seeds carregados — **76 órgãos** (47 da estrutura + 29 gabinetes), 20ª Legislatura, 8 tipos,
  6 papéis, 8 permissões, 12 fases, 14 transições.
- **Segurança:** RLS habilitado em todas as tabelas (advisors de erro resolvidos; restam apenas
  avisos `INFO` de "RLS sem policy", esperado até as políticas por papel serem criadas).

> As **chaves/segredos** do projeto NÃO são versionadas. Pegue a URL e a chave *publishable* no
> painel do Supabase (Project Settings → API) ao configurar a aplicação.

## Pendências antes de produção

- Criar **policies de RLS** por papel/órgão (RLS já está habilitado/travado).
- Definir política de **numeração** (reinício anual?) com a Secretaria-Geral.
- Validar o fluxo de `fase`/`transicao` com o Regimento Interno.
