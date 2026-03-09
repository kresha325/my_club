# White‑Label Sports Club Platform (Flutter + Firebase skeleton)

Clean, modular starter for a multi‑club (white‑label) sports platform.
Everything is **blank by default** so an admin can populate it.

## Features

**Public app (Web + Android + iOS)**
- Home (news/events/gallery/ads placeholders)
- Team (athletes)
- Gallery (photos/videos placeholders)
- Results (matches)
- Events
- Sponsors + Ads
- Live Streaming (embed placeholder)
- Membership (monetization placeholder)

**Admin**
- Email/password login (Firebase Auth)
- Admin allowlist: create `admins/{uid}` in Firestore
- CRUD: athletes, news, events, matches, gallery, sponsors, ads
- Media upload to Firebase Storage (Gallery)
- Autopost job queue + trigger placeholder (YouTube/Instagram/Facebook)

## Firestore collections (empty)

- `athletes`
- `news`
- `events`
- `matches`
- `gallery`
- `sponsors`
- `ads`
- `admins` (admin allowlist)
- `autopost_jobs` (queue for Functions)

## Folder structure

Inside `lib/`:
- `models/` data models
- `services/` Firebase + repository + autopost placeholders
- `pages/` public + admin pages
- `widgets/` reusable UI components
- `utils/` helpers, constants, theme

## Setup (recommended)

1) Install dependencies:
   - `flutter pub get`

2) Connect Firebase:
   - Install FlutterFire CLI
   - Run: `flutterfire configure`
   - Replace the placeholder `lib/firebase_options.dart`

3) Firebase Functions (optional):
   - Skeleton lives in `functions/`
   - Deploy with: `firebase deploy --only functions`

## Notes

- Autoposting is intentionally **server-side** (Firebase Functions) to keep API
  keys and access tokens off the client.
- Rules/config files are included as a skeleton; tighten them before production.
