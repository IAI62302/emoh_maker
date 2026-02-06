import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../domain/due_date_item.dart';
import '../data/due_date_repository.dart';

final dueDateBoxProvider = Provider<Box<DueDateItem>>(
  (ref) => Hive.box<DueDateItem>('due_dates'),
);

final dueDateRepositoryProvider = Provider<DueDateRepository>(
  (ref) => DueDateRepository(ref.read(dueDateBoxProvider)),
);