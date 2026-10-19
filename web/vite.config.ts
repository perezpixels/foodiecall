import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

export default defineConfig({
  plugins: [react()],
  // Local Flutter host: /react/ · GitHub Pages: /foodiecall/react/ (set VITE_BASE in CI)
  base: process.env.VITE_BASE || '/react/',
  server: {
    port: 5173,
    strictPort: true,
  },
  build: {
    outDir: '../admin/web/react',
    emptyOutDir: true,
  },
})
