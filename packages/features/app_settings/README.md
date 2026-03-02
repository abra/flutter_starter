# app_settings

Manages user preferences: theme mode, seed color, and locale.
Persists to SharedPreferences automatically. Streams changes to the widget tree via `AppSettingsBuilder`.

---

## Architecture

Layered architecture following sizzle_starter:

```
domain/       AppSettings model, AppSettingsRepository (interface)
data/         AppSettingsCodec, AppSettingsLocalDatasource, AppSettingsRepositoryImpl
application/  AppSettingsService (interface + impl with MutexLock)
presentation/ AppSettingsScope (InheritedWidget), AppSettingsBuilder (StreamBuilder)
              AppSettingsContainer (wires all layers)
```

---

## What's included

| Class | Description |
|---|---|
| `AppSettings` | Immutable model: `ThemeMode`, `Color`, `Locale` |
| `AppSettingsService` | Loads from disk on startup, persists on update, streams changes |
| `AppSettingsContainer` | Wires all layers; created once in `composition.dart` |
| `AppSettingsScope` | Pure `InheritedWidget` — provides container, does NOT rebuild |
| `AppSettingsBuilder` | `StreamBuilder` — rebuilds subtree when settings change |

---

## Usage

### Read settings (rebuilds on change)

```dart
AppSettingsBuilder(
  builder: (context, settings) {
    return Text(settings.themeMode.name);
  },
)
```

### Update settings

```dart
AppSettingsScope.of(context).settingsService.update(
  (s) => s.copyWith(themeMode: ThemeMode.dark),
);
```

Changes are persisted to SharedPreferences immediately and streamed to all `AppSettingsBuilder` widgets.

---

## Wiring

`AppSettingsContainer` is created in `composition.dart` and stored in `DependenciesContainer`.
`DependenciesScope` automatically wraps the widget tree in `AppSettingsScope` — no manual placement needed.

```
DependenciesScope
  └─ AppSettingsScope       ← holds AppSettingsContainer (no rebuild)
       └─ MaterialContext
            └─ AppSettingsBuilder  ← rebuilds MaterialApp on settings change
                 └─ your app
```
