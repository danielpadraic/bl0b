// navigation.js
// This file acts as a compatibility layer for components still using svelte-routing

// Export a navigate function that uses our custom window.navigateTo instead
export function navigate(to, options = {}) {
    if (typeof window !== 'undefined' && window.navigateTo) {
      window.navigateTo(to);
    } else {
      console.warn('Navigation attempted before navigateTo was initialized');
    }
  }
  
  // Patch Link and Route components with dummy implementations for any imports that can't be removed
  export function Link() {}
  export function Route() {}
  export function Router() {}