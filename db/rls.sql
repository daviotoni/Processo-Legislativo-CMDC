-- =============================================================================
-- Seguranca: habilita RLS (Row Level Security) em todas as tabelas do schema public.
-- Sem policies, o acesso via API publica (anon/authenticated) fica NEGADO;
-- o backend acessa via service_role (que ignora RLS). As policies por papel/orgao
-- serao adicionadas junto com a camada de autenticacao.
-- Resolve o lint 0013 (rls_disabled_in_public) do Supabase.
-- =============================================================================
DO $$
DECLARE t text;
BEGIN
  FOR t IN SELECT tablename FROM pg_tables WHERE schemaname = 'public'
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY;', t);
  END LOOP;
END $$;
