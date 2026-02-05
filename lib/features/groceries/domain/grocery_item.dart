import 'package:uuid/uuid.dart';

class GroceryItem {
  final String id;
  final String title;
  final bool isBought;

  GroceryItem({
    required this.id,
    required this.title,
    this.isBought = false,
  });

  factory GroceryItem.create(String title) {
    return GroceryItem(
      id: const Uuid().v4(),
      title: title,
    );
  }

  GroceryItem copyWith({
    String? title,
    bool? isBought,
  }) {
    return GroceryItem(
      id: id,
      title: title ?? this.title,
      isBought: isBought ?? this.isBought,
    );
  }
}