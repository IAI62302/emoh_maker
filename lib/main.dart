import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planit_family/features/due_dates/domain/due_date_item.dart';

import 'app.dart';
import 'features/groceries/domain/grocery_item.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(GroceryItemAdapter());
  await Hive.openBox<GroceryItem>('groceries');
  Hive.registerAdapter(DueDateItemAdapter());
  await Hive.openBox<DueDateItem>('due_dates');

  runApp(
    const ProviderScope(
      child: HouseholdApp(),
    ),
  );
}