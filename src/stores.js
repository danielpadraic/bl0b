import { writable } from 'svelte/store';

// Store for controlling ChallengeCreation modal
export const showChallengeCreation = writable(false);

// Store for authenticated user
export const user = writable(null);