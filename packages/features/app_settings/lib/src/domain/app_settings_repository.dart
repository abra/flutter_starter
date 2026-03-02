import 'package:app_settings/src/domain/app_settings.dart';

abstract interface class AppSettingsRepository {
  Future<AppSettings> read();
  Future<void> save(AppSettings settings);
}
