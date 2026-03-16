# component_library

UI components and design system.

---

## Theme

Two layers:
- **`AppThemeData`** — describes the color scheme and component styles
- **`AppTheme`** — InheritedWidget that provides the theme to the widget tree

`AppTheme.of(context)` automatically returns the light or dark theme based on
`Theme.of(context).brightness`.

```dart
final theme = AppTheme.of(context);
return Card(color: theme.cardBackgroundColor);
```

To add custom colors: declare an abstract getter in `AppThemeData`, implement in
`LightAppThemeData` and `DarkAppThemeData`. See `.docs/THEMING.md` for a full guide.

---

## Design tokens

### Spacing

| Constant | Value |
|---|---|
| `Spacing.xSmall` | 4 |
| `Spacing.small` | 8 |
| `Spacing.medium` | 12 |
| `Spacing.mediumLarge` | 16 |
| `Spacing.large` | 20 |
| `Spacing.xLarge` | 24 |
| `Spacing.xxLarge` | 48 |
| `Spacing.xxxLarge` | 64 |

### FontSize

| Constant | Value |
|---|---|
| `FontSize.small` | 11 |
| `FontSize.medium` | 14 |
| `FontSize.mediumLarge` | 18 |
| `FontSize.large` | 22 |
| `FontSize.xLarge` | 32 |
| `FontSize.xxLarge` | 48 |

### IconSize

| Constant | Value |
|---|---|
| `IconSize.xSmall` | 14 |
| `IconSize.small` | 18 |
| `IconSize.medium` | 20 |
| `IconSize.large` | 24 |
| `IconSize.xLarge` | 28 |

### AppRadius

| Constant | Value |
|---|---|
| `AppRadius.xSmall` | 2 |
| `AppRadius.small` | 12 |
| `AppRadius.medium` | 14 |
| `AppRadius.large` | 20 |

```dart
padding: const EdgeInsets.all(Spacing.mediumLarge)   // 16
fontSize: FontSize.medium                             // 14
Icon(Icons.close, size: IconSize.medium)              // 20
BorderRadius.circular(AppRadius.small)                // 12
```

---

## Widgets

### BottomSheetHeader

Title + close button row for bottom sheets.

```dart
BottomSheetHeader(
  title: 'Settings',
  onClose: () => Navigator.of(context).pop(),
)
```

### CenteredCircularProgressIndicator

`CircularProgressIndicator` wrapped in `Center`.

```dart
const CenteredCircularProgressIndicator()
```

### EmptyState

Centered text message for empty lists.

```dart
EmptyState(message: 'No items yet')
```

### ErrorState

Centered error message with a retry button.

```dart
ErrorState(
  message: 'Failed to load',
  retryLabel: 'Retry',
  onRetry: () => bloc.add(const MyStarted()),
)
```

### FadeGradientOverlay

Gradient fade pinned to the bottom of a `Stack`. Fades from transparent to scaffold
background, sits above scrollable content without blocking taps.

```dart
Stack(
  children: [
    // scrollable content...
    FadeGradientOverlay(height: 80),
    // bottom toolbar...
  ],
)
```

---

## Package structure

```
lib/
  component_library.dart          ← barrel export
  src/
    bottom_sheet_header.dart
    centered_circular_progress_indicator.dart
    empty_state.dart
    error_state.dart
    fade_gradient_overlay.dart
    theme/
      app_radius.dart
      app_theme.dart
      app_theme_data.dart
      font_size.dart
      icon_size.dart
      spacing.dart
```
