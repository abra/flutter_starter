# flutter_starter

A lightweight Flutter code template with clean architecture, BLoC, and modular feature packages.
Inspired by [sizzle_starter](https://github.com/hawkkiller/sizzle_starter) — a simplified version without the full monorepo setup, intended as a starting point for small to medium apps.

## What's included

```
lib/
  main.dart                     — delegates to starter()
  bootstrap/
    starter.dart                — runZonedGuarded, error handling, runApp
    composition.dart            — composeDependencies() → CompositionResult
    application_config.dart     — compile-time constants via --dart-define
    environment.dart            — enum Environment (dev / staging / prod)
    app_bloc_observer.dart      — global BLoC logging
    bloc_transformer.dart       — SequentialBlocTransformer (asyncExpand)
    dependency_container.dart   — DependenciesContainer + TestDependenciesContainer
  app/
    root_context.dart           — DependenciesScope → MaterialContext
    dependency_scope.dart       — InheritedWidget for DependenciesContainer + AppSettingsScope
    material_context.dart       — MaterialApp wired to AppSettingsScope (theme, locale)
    media_query.dart            — clamps text scale factor at root
    initialization_failed.dart  — error screen with retry button
    routing.dart                — route name constants
  utils/
    inherited_extension.dart    — inhOf / inhMaybeOf helpers
    string_extension.dart       — String.limit(n) for log truncation
packages/
  features/
    app_settings/                 — theme mode, seed color, locale (SharedPreferences)
  component_library/            — shared UI: theme, design tokens, common widgets (create when needed)
  monitoring/                   — Logger, ErrorReportingService, AnalyticsReporter
```

## packages/features/app_settings

Manages user preferences: theme mode (light/dark/system), seed color, and locale.
Persists to SharedPreferences automatically. Ready to use out of the box.

```dart
// Rebuild on change:
AppSettingsBuilder(
  builder: (context, settings) {
    return Text(settings.themeMode.name);
  },
)

// Update (persists immediately):
AppSettingsScope.of(context).settingsService.update(
  (s) => s.copyWith(themeMode: ThemeMode.dark),
);
```

`MaterialContext` wraps `MaterialApp` in `AppSettingsBuilder` — theme and locale switch automatically.

For adding translations, see [L10N.md](L10N.md).

## packages/monitoring

`Logger` and `ErrorReportingService` are ready and wired in `starter.dart`.
See [packages/monitoring/README.md](packages/monitoring/README.md) for full usage.

## Architecture overview

Dependencies flow in one direction:

```
packages/features/*   →   lib/bootstrap/composition.dart   →   DependenciesContainer
                                                                       ↓
                                                           DependenciesScope (InheritedWidget)
                                                                       ↓
                                                           AppSettingsScope → MaterialContext
                                                                       ↓
                                                                 feature screens
```

- Global dependencies are created once in `composition.dart` and stored in `DependenciesContainer`
- `DependenciesScope` exposes the container to the widget tree without singletons or service locators
- `AppSettingsScope` is a pure `InheritedWidget` holding `AppSettingsContainer` — never rebuilds on settings change
- `AppSettingsBuilder` is the `StreamBuilder` — placed only where settings changes need to trigger a rebuild
- Feature BLoCs access dependencies via `DependenciesScope.of(context)`

## How to use

See [SETUP.md](SETUP.md).
