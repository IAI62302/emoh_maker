import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:planit_family/features/due_dates/data/due_date_repository.dart';
import '../domain/due_date_item.dart';
import 'due_date_providers.dart';

class DueDateNotifier extends StateNotifier<List<DueDateItem>> {
  final DueDateRepository _repository;

  DueDateNotifier(this._repository)
      : super(_repository.getAllSorted());

  Future<void> add(String title, DateTime date) async {
    final item = DueDateItem.create(
      title: title,
      dueDate: date,
    );

    await _repository.add(item);
    state = _repository.getAllSorted();
  }

  Future<void> toggleDone(String id) async {
    final item = state.firstWhere((e) => e.id == id);
    final updated = item.copyWith(isDone: !item.isDone);

    await _repository.update(updated);
    state = _repository.getAllSorted();
  }

  Future<void> remove(String id) async {
    await _repository.delete(id);
    state = _repository.getAllSorted();
  }
}

final dueDateProvider =
    StateNotifierProvider<DueDateNotifier, List<DueDateItem>>(
  (ref) => DueDateNotifier(
    ref.read(dueDateRepositoryProvider),
  ),
);