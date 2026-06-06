# VIBE App — Test Suite

## How to Run All Tests

```bash
cd VIBE-flutter-project
flutter test
```

To run a specific category:

```bash
# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Riverpod tests only
flutter test test/riverpod/

# Integration tests only
flutter test test/integration/
```

To run with verbose output (shows every test name):

```bash
flutter test --reporter expanded
```

---

## Test Structure

```
test/
├── unit/
│   ├── user_model_test.dart          — UserModel JSON/DB parsing & round-trips
│   ├── post_model_test.dart          — PostModel JSON/DB parsing & defaults
│   ├── auth_state_test.dart          — AuthState sealed class variants
│   ├── email_entry_state_test.dart   — EmailEntryState + email validation logic
│   └── notification_model_test.dart  — NotificationModel JSON/DB parsing
│
├── widget/
│   ├── custom_bottom_nav_test.dart   — CustomBottomNavBar rendering & taps
│   ├── splash_screen_test.dart       — SplashScreen layout & styling
│   └── auth_text_field_test.dart     — AuthTextField label/error/password toggle
│
├── riverpod/
│   ├── category_notifier_test.dart   — CategoryNotifier state & reactivity
│   ├── auth_notifier_test.dart       — AuthNotifier with fake override
│   └── connection_notifier_test.dart — ConnectionActionNotifier idle state
│
└── integration/
    └── app_integration_test.dart     — Full ProviderScope + widget tree tests
```

---

## Test Coverage Summary

| Layer        | Files Tested                                    | Test Count |
|--------------|-------------------------------------------------|------------|
| Unit         | UserModel, PostModel, AuthState, EmailEntryState, NotificationModel | 30+ |
| Widget       | CustomBottomNavBar, SplashScreen, AuthTextField | 20+ |
| Riverpod     | CategoryNotifier, AuthNotifier, ConnectionActionNotifier | 15+ |
| Integration  | Auth + Nav + Theme + Provider wiring            | 10+ |

---

## Key Design Decisions

- **No real network/DB calls in tests** — Riverpod tests use `ProviderContainer`
  isolation; the integration tests override `authNotifierProvider` with a
  `_FakeAuthNotifier` that returns a known `AuthState` without touching
  `FlutterSecureStorage` or SQLite.

- **Widget tests are self-contained** — each widget is pumped inside a bare
  `MaterialApp` or `UncontrolledProviderScope` so tests run without
  platform channels.

- **State machine coverage** — every `AuthState` and `EmailEntryState` variant
  is exercised in the unit tests, including the sealed-class switch statements.
