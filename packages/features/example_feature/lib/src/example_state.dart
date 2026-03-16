part of 'example_bloc.dart';

enum ExampleStatus { initial, loading, success, failure }

final class ExampleState extends Equatable {
  const ExampleState({
    this.status = ExampleStatus.initial,
    this.items = const [],
    this.error,
  });

  final ExampleStatus status;
  final List<String> items;
  final Object? error;

  ExampleState copyWith({
    ExampleStatus? status,
    List<String>? items,
    Object? error,
  }) {
    return ExampleState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
