import svelte from 'rollup-plugin-svelte';
import resolve from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import livereload from 'rollup-plugin-livereload';
import terser from '@rollup/plugin-terser';
import css from 'rollup-plugin-css-only';

const production = !process.env.ROLLUP_WATCH;

export default {
  input: 'src/main.js',
  output: {
    sourcemap: true,
    format: 'esm',
    dir: 'public/build',
    entryFileNames: production ? '[name].[hash].js' : 'main.js'
  },
  plugins: [
    svelte({
      compilerOptions: {
        dev: !production
      }
    }),
    css({ output: 'bundle.css' }), // Outputs to public/build/bundle.css
    resolve({
      browser: true,
      dedupe: ['svelte']
    }),
    commonjs(),
    !production && livereload('public'),
    production && terser()
  ],
  watch: {
    clearScreen: false
  },
  onwarn(warning, warn) {
    if (warning.code === 'THIS_IS_UNDEFINED') return;
    warn(warning);
  }
};