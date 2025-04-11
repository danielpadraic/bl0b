import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error(
    'Supabase configuration failed: VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY must be defined in your .env file.'
  );
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);