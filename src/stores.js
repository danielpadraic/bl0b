import { writable } from 'svelte/store';
import { supabase } from './supabase.js';

export const showChallengeCreation = writable(false);
export const showTaskCompletionForm = writable(false);
export const user = writable(null);

// Initialize the user store with the current session
supabase.auth.getSession().then(({ data }) => {
  if (data && data.session) {
    user.set(data.session.user);
    console.log("Initial session user:", data.session.user);
  } else {
    user.set(null);
    console.log("No initial session found");
  }
});

// Update user store when auth state changes
supabase.auth.onAuthStateChange((event, session) => {
  user.set(session?.user || null);
  console.log("Auth state changed:", event, session?.user);
});