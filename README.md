# Foodiecall Kitchen

Flutter-first restaurant ordering platform for Nigerian kitchens — **landing**, **kitchen portal (web)**, and a path to **mobile**.

| Surface | Path |
| --- | --- |
| Landing → onboarding → kitchen portal | Flutter app in [`admin/`](admin/) |
| Optional React compare landing | [`web/`](web/) → served at `/react/` |
| Design reference (Stitch) | [`stitch_foodiecall_restaurant/`](stitch_foodiecall_restaurant/) |

## Preview

After GitHub Pages deploys:

- **App:** https://perezpixels.github.io/foodiecall/
- **React compare:** https://perezpixels.github.io/foodiecall/react/

## Local run

```bash
cd admin
flutter pub get
flutter run -d web-server --release --web-port 7357 --web-hostname localhost
```

Open http://localhost:7357 — **Get started** opens kitchen onboarding/sign-in → dashboard. Only the **React** button opens `/react/`.

Rebuild the React compare page into Flutter’s web assets:

```bash
cd web
npm ci
npm run build
```

## Repo

https://github.com/perezpixels/foodiecall
