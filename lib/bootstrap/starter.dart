// Application bootstrap: error zone, Flutter binding initialization, runApp.
//
// Sets up runZonedGuarded to catch all unhandled async errors.
// Configures FlutterError.onError and platformDispatcher.onError so that
// errors at every level are routed to the logger.
// On initialization failure — shows a recovery screen instead of crashing.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/app/initialization_failed.dart';
import 'package:flutter_starter/app/root_context.dart';
import 'package:flutter_starter/bootstrap/app_bloc_observer.dart';
import 'package:flutter_starter/bootstrap/application_config.dart';
import 'package:flutter_starter/bootstrap/bloc_transformer.dart';
import 'package:flutter_starter/bootstrap/composition.dart';
import 'package:flutter_starter/bootstrap/fakes.dart';

/// Initializes dependencies and runs app.
Future<void> starter() async {
  const config = ApplicationConfig();

  // TODO: Replace ErrorReporter with real implementation from packages/monitoring.
  final errorReporter = await createErrorReporter(config);

  // TODO: Replace Logger with real implementation from packages/monitoring.
  final logger = createAppLogger(
    observers: [
      FakeErrorReporterLogObserver(errorReporter),
      if (!kReleaseMode)
        const FakePrintingLogObserver(logLevel: FakeLogLevel.trace),
    ],
  );

  await runZonedGuarded(
    () async {
      // Ensure Flutter is initialized.
      WidgetsFlutterBinding.ensureInitialized();

      // Configure global error interception.
      // TODO: Replace with real logFlutterError / logPlatformDispatcherError from packages/monitoring.
      FlutterError.onError = logger.logFlutterError;
      WidgetsBinding.instance.platformDispatcher.onError =
          logger.logPlatformDispatcherError;

      // Setup bloc observer and transformer.
      Bloc.observer = AppBlocObserver(logger);
      Bloc.transformer = SequentialBlocTransformer<Object?>().transform;

      // Defined as a local function so it can pass itself as onRetryInitialization,
      // allowing the error screen to re-run the full initialization without
      // restarting the process.
      Future<void> composeAndRun() async {
        try {
          final compositionResult = await composeDependencies(
            config: config,
            logger: logger,
            errorReporter: errorReporter,
          );

          runApp(RootContext(compositionResult: compositionResult));
        } on Object catch (e, stackTrace) {
          // Catches both Exception and Error (e.g. OutOfMemoryError),
          // ensuring no failure silently escapes during initialization.
          logger.error(
            'Initialization failed',
            error: e,
            stackTrace: stackTrace,
          );
          runApp(
            InitializationFailedApp(
              error: e,
              stackTrace: stackTrace,
              onRetryInitialization: composeAndRun,
            ),
          );
        }
      }

      // Launch the application.
      await composeAndRun();
    },
    // TODO: Replace with logger.logZoneError from packages/monitoring.
    logger.logZoneError,
  );
}
