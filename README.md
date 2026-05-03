# Pukaar

Flutter daily activity tracker: **Google Sign-In**, **Firestore** for entries (water, steps, calories), **GetX** for routing and state.

## Features

- Login with Google (Firebase Auth).
- **Today**: totals for the current day and add entries from a bottom sheet.
- **History**: past days with per-metric totals; open a day to list or swipe-delete entries.
- **Profile**: account summary and sign-out.

## Run locally

```bash
flutter pub get
flutter run
```

Use iOS Simulator or Android Emulator with Google Sign-In configured for your Firebase project.

### Android: Google Sign-In

Add your **debug SHA-1** (and SHA-256 if required) in [Firebase Console](https://console.firebase.google.com/) → Project settings → Your apps → Android app. Download an updated `google-services.json` if the console prompts you.

```bash
cd android && ./gradlew signingReport
```

Copy the **SHA1** under `Variant: debug` into Firebase, then rebuild.

### Firestore rules

Rules live in [`firestore.rules`](firestore.rules). Deploy after changes:

```bash
firebase deploy --only firestore:rules
```

Rules restrict `users/{uid}` and `users/{uid}/entries/{entryId}` to the signed-in user only.

## Architecture (lib/)

| Area | Role |
|------|------|
| `app/` | `GetMaterialApp`, routes, theme, bindings, auth middleware |
| `data/` | Models, `AuthService`, `FirestoreService` |
| `modules/` | Feature screens: splash, auth, home shell, dashboard, history, profile |
| `shared/` | Date helpers, snackbars, loading / empty widgets |

## Tests

```bash
flutter test
```

Widget tests avoid initializing Firebase by keeping assertions UI-only where needed.
