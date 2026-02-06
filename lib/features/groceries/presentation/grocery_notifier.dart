import 'package:flutter_riverpod/legacy.dart';
import 'package:planit_family/features/groceries/data/grocery_repository.dart';
import '../domain/grocery_item.dart';
import 'grocery_providers.dart';

class GroceryNotifier extends StateNotifier<List<GroceryItem>> {
  final GroceryRepository _repository;

  GroceryNotifier(this._repository)
      : super(_repository.getAll());

  Future<void> addItem(String title) async {
    if (title.trim().isEmpty) return;

    await _repository.add(title);
    state = _repository.getAll();
  }

  Future<void> toggle(String id) async {
    final item = state.firstWhere((e) => e.id == id);
    final updated = item.copyWith(isBought: !item.isBought);

    await _repository.update(updated);
    state = _repository.getAll();
  }

  Future<void> remove(String id) async {
    await _repository.delete(id);
    state = _repository.getAll();
  }
}

final groceryProvider =
    StateNotifierProvider<GroceryNotifier, List<GroceryItem>>(
  (ref) => GroceryNotifier(
    ref.read(groceryRepositoryProvider),
  ),
);