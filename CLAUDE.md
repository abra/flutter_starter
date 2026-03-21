# CLAUDE.md — Flutter Starter Template

## Commands

```bash
make format      # dart format ./ — run after EVERY code change
make analyze     # flutter analyze
make test        # run all tests across all packages
make get         # flutter pub get for root + all packages
make run         # flutter run
make build       # flutter build apk --release
```

> **Always run `dart format ./` after every code change.**

---

## Project Structure

Monorepo: root app shell + independent packages.

```
lib/
  main.dart
  app/
    starter.dart              # Bootstrap: error zones, logger, BLoC setup
    composition.dart          # Wires all dependencies (DependenciesContainer)
    root_context.dart         # Widget tree root: DependenciesScope + PreferencesScope + MaterialContext
    material_context.dart     # StatefulWidget: GoRouter lifecycle + MaterialApp.router
    router/
      app_router.dart         # GoRouter declaration with all routes
      app_routes.dart         # Route path constants
    bloc/
      app_bloc_observer.dart  # Global BLoC observer (logs all events/transitions/errors)
      bloc_transformer.dart   # SequentialBlocTransformer (default for all BLoCs)
    config/
      application_config.dart # Compile-time config (env, Sentry DSN, etc.)
      environment.dart        # Environment enum: dev / staging / prod
    dependency_container.dart # Immutable DI container (plain data class)
    dependency_scope.dart     # InheritedWidget to expose DependenciesContainer
    preferences_scope.dart    # StreamBuilder + InheritedWidget for Preferences
    screens/
      initialization_failed.dart  # Recovery screen shown on bootstrap failure

packages/
  shared/                     # Domain models, interfaces, value objects — no Flutter deps
  monitoring/                 # Logger + ErrorReportingService + AnalyticsReporter
  preferences_service/    # User settings: model, storage, service, scope
  component_library/          # Theme system, spacing/font constants, reusable widgets
  toast_service/              # In-app toast notifications (wraps toastification)
  features/
    example_feature/          # Example BLoC feature — shows the pattern, delete when done
```

---

## Architecture Rules

- **Dependency flow**: `features` → `shared`, `component_library`, `monitoring`. Features never import each other.
- **lib/** knows all packages. Packages never import from **lib/**.
- **No global singletons, no service locators.** All dependencies flow through `DependenciesContainer` → `DependenciesScope`.
- **State management**: BLoC for screens, Cubit for simple state.
- **Navigation**: GoRouter. Created once in `_MaterialContextState.initState()`, disposed in `dispose()`.

---

## Startup Flow

```
main()
  → starter()
    → ApplicationConfig, Logger, ErrorReporter
    → FlutterError.onError / platformDispatcher.onError / runZonedGuarded
    → Bloc.observer = AppBlocObserver
    → Bloc.transformer = SequentialBlocTransformer
    → composeDependencies()
        → PreferencesService.create()
    → runApp(RootContext)
        → DependenciesScope (InheritedWidget)
        → PreferencesScope (StreamBuilder + InheritedWidget)
        → MaterialContext (StatefulWidget)
            → GoRouter created once in initState, disposed in dispose
            → MaterialApp.router
```

---

## DI Container

`DependenciesContainer` fields:

| Field | Type | Purpose |
|---|---|---|
| `logger` | Logger | Global structured logger |
| `config` | ApplicationConfig | isDev / isStaging / isProd flag |
| `errorReporter` | ErrorReportingService | NoopErrorReporter by default (swap for Sentry) |
| `packageInfo` | PackageInfo | App version, build number |
| `preferencesService` | PreferencesService | User settings: load / save / stream |

---

## Preferences (`packages/preferences_service/`)

```dart
class Preferences {
  final ThemeMode themeMode;  // system / light / dark
  final Locale locale;        // selected language
}
```

- `PreferencesService.current` → current settings (synchronous)
- `PreferencesService.stream` → `Stream<Preferences>` emits on every update
- `PreferencesService.update(transform)` → applies transform, persists, emits to stream

Read anywhere with:
```dart
final settings = PreferencesScope.of(context); // listen: true
```

---

## Theme System (`packages/component_library/`)

`AppTheme` (InheritedWidget) — resolves light/dark automatically:
```dart
final theme = AppTheme.of(context);
```

Extend `AppThemeData` to add custom colors:
```dart
// 1. Declare in AppThemeData:
Color get cardBackgroundColor;
// 2. Implement in LightAppThemeData + DarkAppThemeData.
// 3. Use via AppTheme.of(context).cardBackgroundColor.
```

**Design tokens:**

| Spacing | Value | FontSize | Value | IconSize | Value |
|---------|-------|----------|-------|----------|-------|
| `xSmall` | 4 | `small` | 11 | `xSmall` | 14 |
| `small` | 8 | `medium` | 14 | `small` | 18 |
| `medium` | 12 | `mediumLarge` | 18 | `medium` | 20 |
| `mediumLarge` | 16 | `large` | 22 | `large` | 24 |
| `large` | 20 | `xLarge` | 32 | `xLarge` | 28 |
| `xLarge` | 24 | `xxLarge` | 48 | | |
| `xxLarge` | 48 | | | | |
| `xxxLarge` | 64 | | | | |

| AppRadius | Value |
|-----------|-------|
| `xSmall` | 2 |
| `small` | 12 |
| `medium` | 14 |
| `large` | 20 |

**Reusable widgets:**

| Widget | Description |
|--------|-------------|
| `BottomSheetHeader` | Title + close button row for bottom sheets |
| `CenteredCircularProgressIndicator` | Loading spinner wrapped in Center |
| `EmptyState` | Centered message for empty lists |
| `ErrorState` | Error message + retry FilledButton |
| `FadeGradientOverlay` | Gradient fade pinned to bottom of a Stack |

---

## Key Patterns

### Sequential events by default
```dart
Bloc.transformer = SequentialBlocTransformer<Object?>().transform;
```
Every BLoC processes events sequentially. Override per-event with `restartable()`.

### Restartable events
```dart
on<MySearchEvent>(_onSearch, transformer: restartable());
```

### Preferences streaming in BLoC
```dart
await emit.forEach<Preferences>(
  _preferencesService.stream,
  onData: (prefs) => state.copyWith(locale: prefs.locale),
);
```

### Error handling tiers
**Fatal** — block the operation, emit failure state:
- Storage exceptions (DB unreachable, etc.)

**Non-fatal** — log via `addError()`, don't change state:
- Cleanup operations that run after the main action already succeeded

```dart
// Pattern:
try {
  await _repository.deleteItem(id);
} catch (e, st) {
  addError(e, st);
  emit(state.copyWith(error: e));
  return;
}
// Non-fatal cleanup — log but don't fail:
try {
  await _service.cleanupAfterDelete(id);
} catch (e, st) {
  addError(e, st);
}
emit(state.copyWith(items: updated));
```

### Preferences resilience
`PreferencesService.update()` applies the change in-memory and emits to the stream
regardless of whether persistence succeeds. Save failures are silently swallowed
in `PreferencesService`. The UI stays consistent for the session; on next launch
the old value is restored from disk.

### Toast notifications
```dart
// In MaterialContext — wrap MaterialApp:
ToastWrapper(child: MaterialApp.router(...))

// In feature widgets:
showToast(context, type: NotificationType.success, message: 'Done');
```

---

## Testing Approach

```dart
// Fake repository in each feature's test/helpers/
class FakeExampleRepository implements ExampleRepository {
  bool shouldThrow = false;

  @override
  Future<List<String>> getItems() async {
    if (shouldThrow) throw Exception('getItems failed');
    return ['id_0'];
  }
}

// BLoC test
blocTest<ExampleBloc, ExampleState>(
  'emits loading then success',
  build: () => ExampleBloc(
    repository: FakeExampleRepository(),
  ),
  act: (bloc) => bloc.add(const ExampleStarted()),
  expect: () => [
    const ExampleState(status: ExampleStatus.loading),
    const ExampleState(status: ExampleStatus.success, items: ['id_0']),
  ],
);
```

---

## Where to Add New Code

| What | Where |
|---|---|
| New feature | `packages/features/<name>/` |
| Shared domain model | `packages/shared/lib/src/models/` |
| New setting field | `Preferences` + `PreferencesService` (load/save) |
| New language | ARB files in each feature + `supportedLocales` |
| UI component | `packages/component_library/lib/src/` |
| Infrastructure service | New package under `packages/` |
| New route | `AppRoutes` constants + `app_router.dart` |

---

## Docs

| File | Content |
|---|---|
| `.docs/ARCHITECTURE.md` | Package structure, dependency rules |
| `.docs/THEMING.md` | Theme system guide |
| `.docs/L10N.md` | Localization guide |
| `packages/monitoring/README.md` | Logger, ErrorReporter, Analytics guide |
| `packages/toast_service/README.md` | Toast notification guide |
| `SETUP.md` | How to bootstrap a new project from this template |
