import { createClient, SupabaseClient } from "@supabase/supabase-js";

/**
 * Cliente Supabase com service_role — USO EXCLUSIVO NO SERVIDOR.
 * O acesso ao banco acontece server-side (server actions / server components),
 * portanto a API publica permanece travada pelo RLS. Nunca importar no cliente.
 */
export function supabaseAdmin(): SupabaseClient {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !key) {
    throw new Error(
      "Configure NEXT_PUBLIC_SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY em web/.env.local"
    );
  }
  return createClient(url, key, { auth: { persistSession: false } });
}
