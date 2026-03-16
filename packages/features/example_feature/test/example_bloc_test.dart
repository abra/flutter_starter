import 'package:bloc_test/bloc_test.dart';
import 'package:example_feature/example_feature.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_example_repository.dart';

void main() {
  group('ExampleBloc', () {
    group('ExampleStarted', () {
      blocTest<ExampleBloc, ExampleState>(
        'emits loading then success with items',
        build: () => ExampleBloc(
          repository: FakeExampleRepository(items: ['id_0', 'id_1']),
        ),
        act: (bloc) => bloc.add(const ExampleStarted()),
        expect: () => [
          const ExampleState(status: ExampleStatus.loading),
          const ExampleState(
            status: ExampleStatus.success,
            items: ['id_0', 'id_1'],
          ),
        ],
      );

      blocTest<ExampleBloc, ExampleState>(
        'emits loading then failure on exception',
        build: () => ExampleBloc(
          repository: FakeExampleRepository()..shouldThrow = true,
        ),
        act: (bloc) => bloc.add(const ExampleStarted()),
        verify: (bloc) {
          expect(bloc.state.status, ExampleStatus.failure);
          expect(bloc.state.error, isNotNull);
        },
      );
    });

    group('ExampleItemAdded', () {
      blocTest<ExampleBloc, ExampleState>(
        'adds item to state',
        build: () => ExampleBloc(repository: FakeExampleRepository()),
        seed: () => const ExampleState(
          status: ExampleStatus.success,
          items: ['id_0'],
        ),
        act: (bloc) => bloc.add(const ExampleItemAdded('New item')),
        verify: (bloc) => expect(bloc.state.items, hasLength(2)),
      );

      blocTest<ExampleBloc, ExampleState>(
        'emits error when addItem throws',
        build: () => ExampleBloc(
          repository: FakeExampleRepository()..shouldThrow = true,
        ),
        act: (bloc) => bloc.add(const ExampleItemAdded('title')),
        verify: (bloc) => expect(bloc.state.error, isNotNull),
      );
    });

    group('ExampleItemDeleted', () {
      blocTest<ExampleBloc, ExampleState>(
        'removes item from state',
        build: () => ExampleBloc(repository: FakeExampleRepository()),
        seed: () => const ExampleState(
          status: ExampleStatus.success,
          items: ['id_0', 'id_1'],
        ),
        act: (bloc) => bloc.add(const ExampleItemDeleted('id_0')),
        verify: (bloc) {
          expect(bloc.state.items, ['id_1']);
        },
      );

      blocTest<ExampleBloc, ExampleState>(
        'emits error when deleteItem throws',
        build: () => ExampleBloc(
          repository: FakeExampleRepository()..shouldThrow = true,
        ),
        act: (bloc) => bloc.add(const ExampleItemDeleted('id_0')),
        verify: (bloc) => expect(bloc.state.error, isNotNull),
      );
    });
  });
}
