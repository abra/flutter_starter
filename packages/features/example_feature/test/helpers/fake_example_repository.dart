import 'package:example_feature/example_feature.dart';

class FakeExampleRepository implements ExampleRepository {
  FakeExampleRepository({List<String>? items}) : _items = items ?? [];

  List<String> _items;
  bool shouldThrow = false;

  @override
  Future<List<String>> getItems() async {
    if (shouldThrow) throw Exception('getItems failed');
    return List.of(_items);
  }

  @override
  Future<String> addItem(String title) async {
    if (shouldThrow) throw Exception('addItem failed');
    final id = 'id_${_items.length}';
    _items.add(id);
    return id;
  }

  @override
  Future<void> deleteItem(String id) async {
    if (shouldThrow) throw Exception('deleteItem failed');
    _items.remove(id);
  }
}
