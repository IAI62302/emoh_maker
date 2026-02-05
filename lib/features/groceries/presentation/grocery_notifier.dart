import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/grocery_item.dart';

class GroceryNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryNotifier() : super([]);

  void addItem(String title) {
    if (title.trim().isEmpty) return;

    state = [
      ...state,
      GroceryItem.create(title),
    ];
  }

  void toggleItem(String id) {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(isBought: !item.isBought);
      }
      return item;
    }).toList();
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final groceryProvider =
    StateNotifierProvider<GroceryNotifier, List<GroceryItem>>(
  (ref) => GroceryNotifier(),
);