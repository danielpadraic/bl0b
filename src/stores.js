import { writable } from 'svelte/store';
import { supabase } from './supabase.js';

export const showChallengeCreation = writable(false);
export const showTaskCompletionForm = writable(false);
export const user = writable(null);
export async function setUser() {
  const { data: { user } } = await supabase.auth.getUser();
  user.set(user || null);
}

supabase.auth.getSession().then(({ data: { session } }) => {
  user.set(session?.user ?? null);
  console.log("Initial session user:", session?.user);
});

supabase.auth.onAuthStateChange((event, session) => {
  user.set(session?.user ?? null);
  console.log("Auth state changed:", event, session?.user);
});