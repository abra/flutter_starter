import 'dart:async';
import 'dart:collection';

import 'package:app_settings/src/domain/app_settings.dart';
import 'package:app_settings/src/domain/app_settings_repository.dart';

abstract interface class AppSettingsService {
  /// Emits settings whenever they change.
  Stream<AppSettings> get stream;

  /// Current in-memory settings.
  AppSettings get current;

  /// Update settings transactionally and persist them.
  Future<void> update(AppSettings Function(AppSettings) transform);
}

final class AppSettingsServiceImpl implements AppSettingsService {
  AppSettingsServiceImpl._(this._repository, this._current);

  static Future<AppSettingsServiceImpl> create({
    required AppSettingsRepository repository,
  }) async {
    final current = await repository.read();
    return AppSettingsServiceImpl._(repository, current);
  }

  final AppSettingsRepository _repository;
  final _controller = StreamController<AppSettings>.broadcast();
  final _mutex = _MutexLock();
  AppSettings _current;

  @override
  Stream<AppSettings> get stream => _controller.stream;

  @override
  AppSettings get current => _current;

  @override
  Future<void> update(AppSettings Function(AppSettings) transform) =>
      _mutex.runLocked(() async {
        final updated = transform(_current);
        await _repository.save(updated);
        _current = updated;
        _controller.add(updated);
      });
}

class _MutexLock {
  final _queue = DoubleLinkedQueue<Completer<void>>();

  Future<void> lock() {
    final previous = _queue.lastOrNull?.future ?? Future<void>.value();
    _queue.add(Completer<void>.sync());
    return previous;
  }

  void unlock() {
    if (_queue.isEmpty) return;
    _queue.removeFirst().complete();
  }

  Future<T> runLocked<T>(FutureOr<T> Function() fn) async {
    await lock();
    try {
      return await fn();
    } finally {
      unlock();
    }
  }
}
