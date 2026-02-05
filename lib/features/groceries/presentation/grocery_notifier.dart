import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/grocery_item.dart';

class GroceryNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryNotifier() : super([]);

  void addItem(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;

    state = [...state, GroceryItem.create(trimmed)];
  }

  void toggle(String id) {
    state = state
        .map((item) =>
            item.id == id
                ? item.copyWith(isBought: !item.isBought)
                : item)
        .toList();
  }

  void remove(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final groceryProvider =
    StateNotifierProvider<GroceryNotifier, List<GroceryItem>>(
  (ref) => GroceryNotifier(),
);