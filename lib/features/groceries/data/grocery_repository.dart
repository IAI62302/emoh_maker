import 'package:hive/hive.dart';
import '../domain/grocery_item.dart';
import 'package:uuid/uuid.dart';

class GroceryRepository {
  static const _boxName = 'groceries';
  final Box<GroceryItem> _box;

  GroceryRepository(this._box);

  List<GroceryItem> getAll() {
    return _box.values.toList();
  }

  Future<void> add(String title) async {
    final item = GroceryItem(
      id: const Uuid().v4(),
      title: title.trim(),
    );

    await _box.put(item.id, item);
  }

  Future<void> update(GroceryItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}