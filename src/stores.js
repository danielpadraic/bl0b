import { writable } from 'svelte/store';
import { supabase } from './supabase.js'; // Corrected path based on your setup

// Store for controlling ChallengeCreation modal
export const showChallengeCreation = writable(false);

// Store for authenticated user
export const user = writable(null);

// Check user session on load
supabase.auth.getSession().then(({ data }) => {
  user.set(data.session?.user || null);
});

// Update user when auth state changes
supabase.auth.onAuthStateChange((event, session) => {
  user.set(session?.user || null);
});