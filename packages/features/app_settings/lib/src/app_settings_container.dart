import 'package:app_settings/src/application/app_settings_service.dart';
import 'package:app_settings/src/data/app_settings_datasource.dart';
import 'package:app_settings/src/data/app_settings_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Container that wires all app settings layers.
class AppSettingsContainer {
  const AppSettingsContainer._(this.settingsService);

  final AppSettingsService settingsService;

  static Future<AppSettingsContainer> create({
    required SharedPreferencesAsync sharedPreferences,
  }) async {
    final repository = AppSettingsRepositoryImpl(
      localDatasource: AppSettingsSharedPreferencesDatasource(
        sharedPreferences: sharedPreferences,
      ),
    );
    final service = await AppSettingsServiceImpl.create(repository: repository);
    return AppSettingsContainer._(service);
  }
}
