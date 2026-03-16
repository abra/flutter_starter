part of 'example_bloc.dart';

sealed class ExampleEvent {
  const ExampleEvent();
}

final class ExampleStarted extends ExampleEvent {
  const ExampleStarted();
}

final class ExampleItemAdded extends ExampleEvent {
  const ExampleItemAdded(this.title);
  final String title;
}

final class ExampleItemDeleted extends ExampleEvent {
  const ExampleItemDeleted(this.id);
  final String id;
}
