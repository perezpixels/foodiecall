import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// Marketing site at site root. Kitchen Flutter app is served from /app/.
// GitHub Pages: set VITE_BASE=/foodiecall/
export default defineConfig({
  plugins: [react()],
  base: process.env.VITE_BASE || '/',
  server: {
    port: 5173,
    strictPort: true,
  },
  build: {
    // Keep preview/app (Flutter) when rebuilding the React landing.
    outDir: '../preview',
    emptyOutDir: false,
  },
})
