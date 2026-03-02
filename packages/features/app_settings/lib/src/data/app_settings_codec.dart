import 'dart:ui' show Color, Locale;

import 'package:app_settings/src/domain/app_settings.dart';
import 'package:flutter/material.dart' show ThemeMode;

/// Encodes/decodes [AppSettings] to/from a JSON-compatible map.
class AppSettingsCodec {
  const AppSettingsCodec();

  AppSettings decode(Map<String, Object?> map) {
    final colorMap = map['seedColor'] as Map<String, Object?>?;
    return AppSettings(
      themeMode: ThemeMode.values.byName(map['themeMode'] as String? ?? 'system'),
      seedColor: colorMap != null
          ? Color.from(
              alpha: (colorMap['a'] as num).toDouble(),
              red: (colorMap['r'] as num).toDouble(),
              green: (colorMap['g'] as num).toDouble(),
              blue: (colorMap['b'] as num).toDouble(),
            )
          : const Color(0xFF6200EE),
      locale: Locale(map['locale'] as String? ?? 'en'),
    );
  }

  Map<String, Object?> encode(AppSettings s) => {
    'themeMode': s.themeMode.name,
    'seedColor': {
      'a': s.seedColor.a,
      'r': s.seedColor.r,
      'g': s.seedColor.g,
      'b': s.seedColor.b,
    },
    'locale': s.locale.languageCode,
  };
}
