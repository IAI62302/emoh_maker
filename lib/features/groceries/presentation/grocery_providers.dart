import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../domain/grocery_item.dart';
import '../data/grocery_repository.dart';

final groceryBoxProvider = Provider<Box<GroceryItem>>(
  (ref) => Hive.box<GroceryItem>('groceries'),
);

final groceryRepositoryProvider = Provider<GroceryRepository>(
  (ref) => GroceryRepository(ref.read(groceryBoxProvider)),
);