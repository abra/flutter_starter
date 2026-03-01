// Dependency assembly: creates and wires all application-wide dependencies.
//
// Separates "what to create" from "how to launch" (starter.dart).
// composeDependencies() can be called independently in tests
// with substituted implementations.

import 'package:monitoring/monitoring.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_starter/bootstrap/application_config.dart';
import 'package:flutter_starter/bootstrap/dependency_container.dart';
import 'package:flutter_starter/bootstrap/fakes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A place where Application-Wide dependencies are initialized.
///
/// Application-Wide dependencies are dependencies that have a global scope,
/// used in the entire application and have a lifetime that is the same as the application.
/// Composes dependencies and returns the result of composition.
Future<CompositionResult> composeDependencies({
  required ApplicationConfig config,
  required FakeLogger logger,
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
Future<DependenciesContainer> createDependenciesContainer(
  ApplicationConfig config,
  FakeLogger logger,
  ErrorReportingService errorReporter,
) async {
  final sharedPreferences = SharedPreferencesAsync();
  final packageInfo = await PackageInfo.fromPlatform();

  // TODO: Replace with real SettingsContainer from settings feature package.
  final settingsContainer = await FakeSettingsContainer.create(
    sharedPreferences: sharedPreferences,
  );

  return DependenciesContainer(
    logger: logger,
    config: config,
    errorReporter: errorReporter,
    packageInfo: packageInfo,
    settingsContainer: settingsContainer,
  );
}

/// TODO: Replace with real Logger creation using observers from packages/monitoring.
FakeLogger createAppLogger({List<FakeLogObserver> observers = const []}) {
  final logger = FakeLogger();

  for (final observer in observers) {
    logger.addObserver(observer);
  }

  return logger;
}

/// Creates the [ErrorReportingService] instance.
///
/// Replace [NoopErrorReporter] with a real implementation (e.g. Crashlytics)
/// from packages/monitoring when ready.
Future<ErrorReportingService> createErrorReporter(ApplicationConfig config) async {
  const errorReporter = NoopErrorReporter();

  if (config.enableSentry) {
    await errorReporter.initialize();
  }

  return errorReporter;
}
