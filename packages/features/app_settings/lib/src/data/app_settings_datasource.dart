import 'dart:convert';

import 'package:app_settings/src/data/app_settings_codec.dart';
import 'package:app_settings/src/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppSettingsLocalDatasource {
  Future<AppSettings> read();
  Future<void> save(AppSettings settings);
}

final class AppSettingsSharedPreferencesDatasource implements AppSettingsLocalDatasource {
  const AppSettingsSharedPreferencesDatasource({
    required this.sharedPreferences,
    this.codec = const AppSettingsCodec(),
  });

  static const _key = 'app_settings';

  final SharedPreferencesAsync sharedPreferences;
  final AppSettingsCodec codec;

  @override
  Future<AppSettings> read() async {
    final json = await sharedPreferences.getString(_key);
    if (json == null) return const AppSettings();
    try {
      final map = jsonDecode(json) as Map<String, Object?>;
      return codec.decode(map);
    } catch (_) {
      return const AppSettings();
    }
  }

  @override
  Future<void> save(AppSettings settings) async {
    final map = codec.encode(settings);
    await sharedPreferences.setString(_key, jsonEncode(map));
  }
}
