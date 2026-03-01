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
    fakes.dart                  — temporary stubs for settings (replace with real packages, then delete)
  app/
    root_context.dart           — DependenciesScope → MaterialContext
    dependency_scope.dart       — InheritedWidget for DependenciesContainer
    app_settings_scope.dart     — StreamBuilder<Settings>, propagates settings
    material_context.dart       — MaterialApp wired to settings (theme, locale)
    media_query.dart            — clamps text scale factor at root
    initialization_failed.dart  — error screen with retry button
    routing.dart                — route name constants
  utils/
    inherited_extension.dart    — inhOf / inhMaybeOf helpers
    string_extension.dart       — String.limit(n) for log truncation
packages/
  features/                     — feature packages (notes, auth, profile, etc.)
  component_library/            — shared UI: theme, design tokens, common widgets
  monitoring/                   — Logger, ErrorReportingService, AnalyticsReporter
```

## packages/ — replacing Fake* stubs

`lib/bootstrap/fakes.dart` contains temporary stub implementations for settings-related dependencies.
Each `Fake*` class is a placeholder that should be replaced with a real package from `packages/`
when you're ready to implement it. Once all stubs are replaced, delete `fakes.dart`.

| Fake class | Replace with | Package |
|---|---|---|
| `FakeSettings` / `FakeGeneralSettings` | domain `Settings` model | `packages/features/settings` |
| `FakeSettingsService` | real `SettingsService` (SharedPreferences) | `packages/features/settings` |
| `FakeSettingsContainer` | real `SettingsContainer` | `packages/features/settings` |
| `FakeThemeModeVO` | domain `ThemeModeVO` | `packages/features/settings` |

`Logger` and `ErrorReportingService` are already real — provided by `packages/monitoring`.

### Suggested packages layout

```
packages/
  monitoring/                  — already exists
    lib/
      src/
        logger.dart                        — Logger, LogLevel, LogObserver, LogMessage
        printing_log_observer.dart         — console output via debugPrint
        error_reporting_service.dart       — ErrorReportingService interface + NoopErrorReporter
        error_reporter_log_observer.dart   — bridges Logger errors into ErrorReportingService
        analytics_reporter.dart            — AnalyticsEvent, AnalyticsReporter interface + NoopAnalyticsReporter
  component_library/           — create when needed
    lib/
      src/
        theme.dart             — AppTheme, color tokens
  features/
    settings/                  — create when needed
      lib/
        src/
          settings.dart        — Settings, GeneralSettings domain models
          settings_service.dart
          settings_container.dart
    notes/                     — create when needed
      lib/
        ...
```

Each package is registered in the root `pubspec.yaml`:

```yaml
dependencies:
  monitoring:
    path: packages/monitoring
  component_library:
    path: packages/component_library
  settings:
    path: packages/features/settings
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
- `AppSettingsScope` subscribes to `SettingsService.stream` and rebuilds only the affected subtree
- Feature BLoCs access dependencies via `DependenciesScope.of(context)`

## How to use

See [SETUP.md](SETUP.md).
