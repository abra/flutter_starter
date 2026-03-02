import 'package:app_settings/src/data/app_settings_datasource.dart';
import 'package:app_settings/src/domain/app_settings.dart';
import 'package:app_settings/src/domain/app_settings_repository.dart';

final class AppSettingsRepositoryImpl implements AppSettingsRepository {
  const AppSettingsRepositoryImpl({required this.localDatasource});

  final AppSettingsLocalDatasource localDatasource;

  @override
  Future<AppSettings> read() => localDatasource.read();

  @override
  Future<void> save(AppSettings settings) => localDatasource.save(settings);
}
