import App from './App.svelte';
import './global.css';

// Mock the svelte-routing module
// This needs to happen before any components are initialized that might import from svelte-routing
window.mockSvelteRouting = () => {
  // If any component tries to import from svelte-routing, provide these dummy functions
  window.mockedNavigate = (to) => {
    if (window.navigateTo) {
      window.navigateTo(to);
    } else {
      console.warn('Navigation attempted before navigateTo was initialized');
    }
  };
};

// Call the mock function to set up before app initialization
window.mockSvelteRouting();

// Initialize the app
const app = new App({
  target: document.getElementById('app')
});

export default app;