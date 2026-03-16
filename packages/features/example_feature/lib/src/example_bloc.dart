import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'example_repository.dart';

part 'example_event.dart';
part 'example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleBloc({required ExampleRepository repository})
    : _repository = repository,
      super(const ExampleState()) {
    on<ExampleStarted>(_onStarted);
    on<ExampleItemAdded>(_onItemAdded);
    on<ExampleItemDeleted>(_onItemDeleted);
  }

  final ExampleRepository _repository;

  Future<void> _onStarted(
    ExampleStarted event,
    Emitter<ExampleState> emit,
  ) async {
    emit(state.copyWith(status: ExampleStatus.loading));
    try {
      final items = await _repository.getItems();
      emit(state.copyWith(status: ExampleStatus.success, items: items));
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(status: ExampleStatus.failure, error: e));
    }
  }

  Future<void> _onItemAdded(
    ExampleItemAdded event,
    Emitter<ExampleState> emit,
  ) async {
    try {
      final id = await _repository.addItem(event.title);
      emit(state.copyWith(items: [...state.items, id]));
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(error: e));
    }
  }

  Future<void> _onItemDeleted(
    ExampleItemDeleted event,
    Emitter<ExampleState> emit,
  ) async {
    try {
      await _repository.deleteItem(event.id);
      emit(
        state.copyWith(items: state.items.where((id) => id != event.id).toList()),
      );
    } catch (e, st) {
      addError(e, st);
      emit(state.copyWith(error: e));
    }
  }
}
