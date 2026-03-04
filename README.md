# flutter_starter

A lightweight Flutter project template with clean architecture, BLoC, and modular feature packages.
Inspired by [sizzle_starter](https://github.com/hawkkiller/sizzle_starter) — a simplified version without the full monorepo setup, intended as a starting point for small to medium apps.

## What's included

```
lib/
  main.dart                       — delegates to starter()
  bootstrap/
    starter.dart                  — runZonedGuarded, error handling, runApp
    composition.dart              — composeDependencies() → CompositionResult
    dependency_container.dart     — DependenciesContainer + TestDependenciesContainer
    config/
      application_config.dart     — compile-time constants via --dart-define
      environment.dart            — enum Environment (dev / staging / prod)
    bloc/
      app_bloc_observer.dart      — global BLoC logging
      bloc_transformer.dart       — SequentialBlocTransformer (asyncExpand)
  app/
    root_context.dart             — DependenciesScope → MaterialContext
    dependency_scope.dart         — InheritedWidget for DependenciesContainer + AppSettingsScope
    material_context.dart         — MaterialApp wired to AppTheme + AppSettingsScope
    media_query.dart              — clamps text scale factor at root
    router/
      app_routes.dart             — route name constants
    screens/
      initialization_failed.dart  — error screen with retry button
  utils/
    inherited_extension.dart      — inhOf / inhMaybeOf helpers
    string_extension.dart         — String.limit(n) for log truncation
packages/
  monitoring/                     — Logger, ErrorReportingService, AnalyticsReporter
  preferences_storage/            — SharedPreferences wrapper
  app_settings/                   — theme mode, seed color, locale (persisted)
  component_library/              — AppTheme, AppThemeData, Spacing, FontSize, widgets
  shared/                         — domain: interfaces, models, value objects
  features/                       — your feature packages go here
```

## packages/app_settings

Manages user preferences: theme mode (light/dark/system), seed color, and locale.
Persists to SharedPreferences automatically. Ready to use out of the box.

```dart
// Read settings (subscribes to changes):
final settings = AppSettingsScope.of(context);
Text(settings.themeMode.name);

// Update (persists immediately):
AppSettingsScope.update(
  context,
  (s) => s.copyWith(themeMode: ThemeMode.dark),
);
```

`MaterialContext` wraps `MaterialApp` in `AppTheme` — theme and locale switch automatically.

## packages/component_library

Provides `AppTheme`, `AppThemeData`, `Spacing`, and `FontSize`.

```dart
// Custom theme colors:
final theme = AppTheme.of(context);
color: theme.cardBackgroundColor;

// Design tokens:
padding: const EdgeInsets.all(Spacing.mediumLarge);  // 16
fontSize: FontSize.mediumLarge;                       // 18
```

See [.docs/THEMING.md](.docs/THEMING.md) for how to add custom colors.

## packages/monitoring

`Logger` and `ErrorReportingService` are ready and wired in `starter.dart`.

```dart
logger.info('User signed in');
logger.error('Request failed', error: e, stackTrace: st);
```

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
- `DependenciesScope.of(context)` is called **only in `lib/app/router/`**
- `AppSettingsScope.of(context)` can be used directly in feature widgets (exception — it's a package)
- Feature BLoCs receive dependencies via constructor injection

## Dependency rules

```
lib/                    → packages/*          ✅
packages/*              → packages/*          ✅
packages/features/*     → shared              ✅
packages/features/*     → component_library   ✅
packages/features/*     → lib/               ❌ never
```

## How to use

See [SETUP.md](SETUP.md).

