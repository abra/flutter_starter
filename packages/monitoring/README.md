# monitoring

> **Not production-ready.** `Logger` is a base implementation — functional but lacks production features (batching, sampling, remote sinks). `ErrorReportingService` is an interface with a no-op stub that does nothing. Replace both before shipping.

## What's included

| Class | Type | Status |
|---|---|---|
| `Logger` | base class | Base implementation — functional, but extend for production (batching, sampling, remote sinks) |
| `LogLevel` | enum | Ready |
| `LogObserver` | mixin | Ready |
| `LogMessage` | data class | Ready |
| `PrintingLogObserver` | concrete | Ready for development — prints to console via `debugPrint` |
| `ErrorReportingService` | interface | Must be implemented for production |
| `NoopErrorReporter` | concrete | Stub — does nothing, safe for development |
| `ErrorReporterLogObserver` | concrete | Ready — bridges Logger and ErrorReportingService |

## What to implement for production

### Logger

`Logger` is a base class you can use as-is, but for production consider extending it:

```dart
// In your app or a separate package
final class AppLogger extends Logger {
  // Add sampling, batching, or remote sink here
}
```

### ErrorReportingService

Implement `ErrorReportingService` with a real crash reporting tool:

```dart
// Example: Crashlytics
final class CrashlyticsErrorReporter implements ErrorReportingService {
  @override
  bool get isInitialized => _initialized;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();
    _initialized = true;
  }

  @override
  Future<void> close() async {}

  @override
  Future<void> captureException({
    required Object throwable,
    StackTrace? stackTrace,
  }) => FirebaseCrashlytics.instance.recordError(throwable, stackTrace);
}
```

Then register it in `composition.dart`:

```dart
Future<ErrorReportingService> createErrorReporter(ApplicationConfig config) async {
  final reporter = CrashlyticsErrorReporter();
  if (config.enableSentry) await reporter.initialize();
  return reporter;
}
```
