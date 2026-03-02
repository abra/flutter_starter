import 'package:app_settings/src/domain/app_settings.dart';
import 'package:app_settings/src/presentation/app_settings_scope.dart';
import 'package:flutter/widgets.dart';

/// Rebuilds its subtree whenever [AppSettings] change.
class AppSettingsBuilder extends StatefulWidget {
  const AppSettingsBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, AppSettings settings) builder;

  @override
  State<AppSettingsBuilder> createState() => _AppSettingsBuilderState();
}

class _AppSettingsBuilderState extends State<AppSettingsBuilder> {
  @override
  Widget build(BuildContext context) {
    final service = AppSettingsScope.of(context).settingsService;
    return StreamBuilder<AppSettings>(
      stream: service.stream,
      initialData: service.current,
      builder: (context, snapshot) =>
          widget.builder(context, snapshot.data ?? const AppSettings()),
    );
  }
}
