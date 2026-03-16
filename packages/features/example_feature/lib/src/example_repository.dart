/// Minimal repository interface.
///
/// Replace with your real data source (REST, SQLite, Firebase, etc.).
/// Keep the interface here; put the concrete implementation in a separate
/// infrastructure package so features never depend on storage details.
abstract interface class ExampleRepository {
  Future<List<String>> getItems();
  Future<String> addItem(String title);
  Future<void> deleteItem(String id);
}
