import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

/// Wraps the widget tree to enable toast notifications.
///
/// Place in [MaterialContext] above [MaterialApp]:
///
/// ```dart
/// return ToastWrapper(child: MaterialApp.router(...));
/// ```
class ToastWrapper extends StatelessWidget {
  const ToastWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => ToastificationWrapper(child: child);
}
