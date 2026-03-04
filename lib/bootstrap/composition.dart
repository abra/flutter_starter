// Dependency assembly: creates and wires all application-wide dependencies.
//
// Separates "what to create" from "how to launch" (starter.dart).
// composeDependencies() can be called independently in tests
// with substituted implementations.

import 'package:app_settings/app_settings.dart';
import 'package:monitoring/monitoring.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:preferences_storage/preferences_storage.dart';
import 'package:flutter_starter/bootstrap/config/application_config.dart';
import 'package:flutter_starter/bootstrap/dependency_container.dart';

/// A place where Application-Wide dependencies are initialized.
///
/// Application-Wide dependencies are dependencies that have a global scope,
/// used in the entire application and have a lifetime that is the same as the application.
/// Composes dependencies and returns the result of composition.
Future<CompositionResult> composeDependencies({
  required ApplicationConfig config,
  required Logger logger,
  required ErrorReportingService errorReporter,
}) async {
  final stopwatch = Stopwatch()..start();

  logger.info('Initializing dependencies...');

  final dependencies = await createDependenciesContainer(
    config,
    logger,
    errorReporter,
  );

  stopwatch.stop();
  logger.info(
    'Dependencies initialized successfully in ${stopwatch.elapsedMilliseconds} ms.',
  );

  return CompositionResult(
    dependencies: dependencies,
    millisecondsSpent: stopwatch.elapsedMilliseconds,
  );
}

final class CompositionResult {
  const CompositionResult({
    required this.dependencies,
    required this.millisecondsSpent,
  });

  final DependenciesContainer dependencies;
  final int millisecondsSpent;

  @override
  String toString() =>
      'CompositionResult('
      'dependencies: $dependencies, '
      'millisecondsSpent: $millisecondsSpent'
      ')';
}

/// Creates the initialized [DependenciesContainer].
///
/// Initialization order matters: some services depend on others.
/// Example order for a typical app:
/// ```
/// 1. PreferencesStorage  — no deps, needed by AppSettingsService
/// 2. PackageInfo         — no deps, async platform call
/// 3. AppSettingsService  — needs PreferencesStorage
/// 4. ApiClient           — needs config (baseUrl, apiKey)
/// 5. AuthRepository      — needs ApiClient + PreferencesStorage (token cache)
/// 6. NotesRepository     — needs ApiClient + AuthRepository
/// ```
/// Add new dependencies here and expose them via [DependenciesContainer].
Future<DependenciesContainer> createDependenciesContainer(
  ApplicationConfig config,
  Logger logger,
  ErrorReportingService errorReporter,
) async {
  final preferencesStorage = PreferencesStorage();
  final packageInfo = await PackageInfo.fromPlatform();
  final appSettingsService = await AppSettingsService.create(
    preferencesStorage,
  );

  return DependenciesContainer(
    logger: logger,
    config: config,
    errorReporter: errorReporter,
    packageInfo: packageInfo,
    appSettingsService: appSettingsService,
  );
}

/// Creates the [Logger] instance and attaches any provided observers.
Logger createAppLogger({List<LogObserver> observers = const []}) {
  final logger = Logger();

  for (final observer in observers) {
    logger.addObserver(observer);
  }

  return logger;
}

/// Creates the [ErrorReportingService] instance.
///
/// Replace [NoopErrorReporter] with a real implementation (e.g. Crashlytics)
/// from packages/monitoring when ready.
Future<ErrorReportingService> createErrorReporter(
  ApplicationConfig config,
) async {
  const errorReporter = NoopErrorReporter();

  if (config.enableSentry) {
    await errorReporter.initialize();
  }

  return errorReporter;
}
