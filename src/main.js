import App from './App.svelte';
import { supabase } from './supabase.js';
import { user } from './stores/user.js';
import './global.css'; // Add this

let app;

supabase.auth.onAuthStateChange((event, session) => {
  user.set(session ? session.user : null);
  if (!app) {
    app = new App({ target: document.body });
  }
});

export function start({ target }) {
  if (!app) {
    app = new App({ target });
  }
  return {
    destroy() {
      app.$destroy();
      app = null;
    },
  };
}

export default app;