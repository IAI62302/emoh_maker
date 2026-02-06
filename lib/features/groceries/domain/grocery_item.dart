import 'package:hive/hive.dart';

part 'grocery_item.g.dart';

@HiveType(typeId: 1)
class GroceryItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isBought;

  GroceryItem({
    required this.id,
    required this.title,
    this.isBought = false,
  });

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