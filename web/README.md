# Foodiecall marketing site (React)

Built into the Flutter web host at `/react/` so both landings share **http://localhost:7357**.

## Develop

```bash
npm install
npm run dev
```

Dev server stays on :5173. For the shared-port build:

```bash
npm run build
```

This writes to `../admin/web/react`. Then rebuild/serve Flutter admin on :7357.

## Compare

- Flutter landing: http://localhost:7357/
- React landing: http://localhost:7357/react/
- Get started → http://localhost:7357/?admin=1 (kitchen sign-in)
