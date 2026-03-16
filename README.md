# flutter_starter

Production-ready Flutter monorepo template. Clean architecture, BLoC, GoRouter,
modular feature packages, theming, settings, logging, and toast notifications —
wired up and ready to go.

## What's included

| Package | Description |
|---|---|
| `monitoring` | Structured logger, error reporter (Sentry-ready), analytics reporter |
| `preferences_service` | User settings (theme, locale) with persistence and streaming |
| `component_library` | Theme system, design tokens (Spacing, FontSize, IconSize, AppRadius), reusable widgets |
| `toast_service` | In-app toast notifications (wraps toastification, swappable) |
| `shared` | Domain models, interfaces, value objects — no Flutter deps |
| `features/example_feature` | Example BLoC feature — shows the full pattern, delete when done |

## Architecture

```
lib/                      ← app shell (router, DI, bootstrap)
packages/
  shared/                 ← domain layer (no Flutter)
  monitoring/             ← logging + error reporting
  preferences_service/← user preferences
  component_library/      ← design system
  toast_service/          ← notifications
  features/
    example_feature/      ← example — delete and replace with your own
```

**Dependency rules:** features depend on shared, component_library, monitoring.
Features never import each other. `lib/` is the only place that knows everything.

## Quick start

```bash
# 1. Clone or copy the template
git clone <this-repo> my_app
cd my_app

# 2. Run the setup script (renames flutter_starter → your app name)
bash setup.sh my_app

# 3. Install dependencies
make get

# 4. Run
make run
```

See [SETUP.md](SETUP.md) for full setup instructions.

## Commands

```bash
make get       # pub get for root + all packages
make format    # dart format ./
make analyze   # flutter analyze
make test      # run all package tests
make run       # flutter run
make build     # flutter build apk --release
```

## Key patterns

### BLoC + sequential events
```dart
// All BLoCs process events sequentially by default (no races).
Bloc.transformer = SequentialBlocTransformer<Object?>().transform;

// Override per-event with restartable() for search/load:
on<SearchQueryChanged>(_onSearch, transformer: restartable());
```

### Settings
```dart
// Read (subscribes to changes):
final settings = PreferencesScope.of(context);

// Update (persists immediately):
PreferencesScope.update(context, (s) => s.copyWith(themeMode: ThemeMode.dark));
```

### Theme
```dart
final theme = AppTheme.of(context); // auto light/dark
color: theme.cardBackgroundColor;
padding: const EdgeInsets.all(Spacing.mediumLarge); // 16
```

### Toast
```dart
// Wrap MaterialApp once:
ToastWrapper(child: MaterialApp.router(...))

// Show anywhere:
showNotification(context, type: NotificationType.success, message: 'Saved');
```

## Documentation

| File | Content |
|---|---|
| `CLAUDE.md` | Full architecture reference, patterns, where to add new code |
| `packages/monitoring/README.md` | Logger, error reporter, analytics setup |
| `packages/toast_service/README.md` | Toast notifications, swapping the library |
| `SETUP.md` | Bootstrap a new project from this template |
