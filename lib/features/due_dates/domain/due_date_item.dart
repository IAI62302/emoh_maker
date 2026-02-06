import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'due_date_item.g.dart';

@HiveType(typeId: 2) // MUST be unique
class DueDateItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime dueDate;

  @HiveField(3)
  final bool isDone;

  DueDateItem({
    required this.id,
    required this.title,
    required this.dueDate,
    this.isDone = false,
  });

  factory DueDateItem.create({
    required String title,
    required DateTime dueDate,
  }) {
    return DueDateItem(
      id: const Uuid().v4(),
      title: title.trim(),
      dueDate: dueDate,
    );
  }

  DueDateItem copyWith({
    String? title,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return DueDateItem(
      id: id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}