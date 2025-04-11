import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default defineConfig({
  plugins: [
    svelte({
      compilerOptions: {
        compatibility: {
          componentApi: 4, // Enables Svelte 3/4 component API compatibility
        },
      },
    }),
  ],
  build: {
    outDir: 'public/build',
  },
  server: {
    port: 5173,
    open: true,
  },
});