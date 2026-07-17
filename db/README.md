# Banco de dados

Esquema e dados iniciais do MVP (PostgreSQL / Supabase).

## Arquivos (ordem de execução)

1. [`schema.sql`](schema.sql) — DDL do MVP (Fase 0 + Fase 1).
2. [`seed.sql`](seed.sql) — tipos de proposição, papéis, permissões, fases, transições, mapa papel→permissão.
3. [`seed_orgaos.sql`](seed_orgaos.sql) — estrutura de órgãos (Lei 3.525/2025, art. 2º).

```bash
psql "$DATABASE_URL" -f db/schema.sql
psql "$DATABASE_URL" -f db/seed.sql
psql "$DATABASE_URL" -f db/seed_orgaos.sql
```

## Ambiente provisionado (Supabase)

- **Projeto:** `processo-legislativo-cmdc` · **ref:** `yqnthodhudvzkhagozbb` · **região:** `sa-east-1` (São Paulo)
- Estado atual: schema aplicado (migration `mvp_schema_fase0_fase1`) + seeds carregados (46 órgãos, 8 tipos, 6 papéis, 8 permissões, 12 fases).

> As **chaves/segredos** do projeto NÃO são versionadas. Pegue a URL e a chave *publishable* no
> painel do Supabase (Project Settings → API) ao configurar a aplicação.

## Pendências antes de produção

- Habilitar **RLS (Row Level Security)** por papel/órgão nas tabelas sensíveis.
- Definir política de **numeração** (reinício anual?) com a Secretaria-Geral.
- Validar o fluxo de `fase`/`transicao` com o Regimento Interno.
