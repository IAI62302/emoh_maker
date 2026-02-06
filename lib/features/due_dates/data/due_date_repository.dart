import 'package:hive/hive.dart';
import '../domain/due_date_item.dart';

class DueDateRepository {
  static const _boxName = 'due_dates';
  final Box<DueDateItem> _box;

  DueDateRepository(this._box);

  List<DueDateItem> getAllSorted() {
    final items = _box.values.toList();
    items.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return items;
  }

  Future<void> add(DueDateItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> update(DueDateItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}