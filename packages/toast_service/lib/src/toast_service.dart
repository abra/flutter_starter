import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum NotificationType { success, error }

/// Shows an in-app toast notification.
///
/// Call from anywhere that has a [BuildContext].
///
/// ```dart
/// showNotification(
///   context,
///   type: NotificationType.success,
///   message: 'Saved',
/// );
/// ```
void showNotification(
  BuildContext context, {
  required NotificationType type,
  required String message,
}) {
  toastification.show(
    context: context,
    type: switch (type) {
      NotificationType.success => ToastificationType.success,
      NotificationType.error => ToastificationType.error,
    },
    title: Text(message),
    autoCloseDuration: const Duration(seconds: 3),
  );
}
