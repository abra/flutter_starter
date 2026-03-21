# toast_service

Thin wrapper over [toastification](https://pub.dev/packages/toastification) for in-app
notifications.

## Why this package exists

Feature packages should not import `toastification` directly. By routing all toast calls
through this package, the underlying library can be swapped out in one place without
touching any feature code.

## API

```dart
// Wrap the widget tree (in MaterialContext, above MaterialApp)
ToastWrapper(child: child)

// Show a toast
showToast(
  context,
  type: NotificationType.success,
  message: 'Saved',
);
```

`NotificationType` has two values: `success` and `error`.

## Swapping the library

All implementation details live in `lib/src/`. To replace `toastification`:

1. Update `pubspec.yaml` — remove `toastification`, add the new library.
2. Rewrite `toast_service.dart` and `toast_wrapper.dart` using the new library's API.
3. Feature packages and the app shell are unaffected.
