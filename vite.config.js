import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default defineConfig({
  plugins: [
    svelte(),
  ],
  build: {
    outDir: 'public/build',
  },
  server: {
    port: 5173,
    open: true,
  }
});