import 'package:preferences_service/preferences_service.dart';
import 'package:flutter/widgets.dart';

/// Listens to [PreferencesService] and provides [Preferences] to the subtree.
class PreferencesScope extends StatelessWidget {
  const PreferencesScope({
    required this.service,
    required this.child,
    super.key,
  });

  final PreferencesService service;
  final Widget child;

  /// Returns current [Preferences] and subscribes to changes.
  static Preferences of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SettingsInherited>()!.settings;

  /// Updates preferences without subscribing to changes.
  static Future<void> update(
    BuildContext context,
    Preferences Function(Preferences) transform,
  ) => context
      .getInheritedWidgetOfExactType<_SettingsInherited>()!
      .service
      .update(transform);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Preferences>(
      stream: service.stream,
      initialData: service.current,
      builder: (context, snapshot) {
        return _SettingsInherited(
          settings: snapshot.data!,
          service: service,
          child: child,
        );
      },
    );
  }
}

class _SettingsInherited extends InheritedWidget {
  const _SettingsInherited({
    required super.child,
    required this.settings,
    required this.service,
  });

  final Preferences settings;
  final PreferencesService service;

  @override
  bool updateShouldNotify(_SettingsInherited old) => settings != old.settings;
}
