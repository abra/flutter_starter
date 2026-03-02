import 'package:app_settings/src/app_settings_container.dart';
import 'package:flutter/widgets.dart';

/// Provides [AppSettingsContainer] to the widget subtree.
///
/// Does NOT rebuild when settings change — use [AppSettingsBuilder] for that.
class AppSettingsScope extends InheritedWidget {
  const AppSettingsScope({
    required this.settingsContainer,
    required super.child,
    super.key,
  });

  final AppSettingsContainer settingsContainer;

  static AppSettingsContainer of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found in widget tree');
    return scope!.settingsContainer;
  }

  @override
  bool updateShouldNotify(AppSettingsScope old) =>
      !identical(settingsContainer, old.settingsContainer);
}
