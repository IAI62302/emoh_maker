import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'due_date_notifier.dart';
import '../domain/due_date_item.dart';

class DueDatesPage extends ConsumerWidget {
  const DueDatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(dueDateProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: items.isEmpty
          ? const _EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _DueDateTile(item: item);
              },
            ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add Due Date',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Pay electricity bill',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '${selectedDate.toLocal()}'.split(' ')[0],
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 1)),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365 * 5)),
                          );
                          if (date != null) {
                            setState(() => selectedDate = date);
                          }
                        },
                        child: const Text('Pick date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(dueDateProvider.notifier)
                            .add(titleController.text, selectedDate);
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _DueDateTile extends ConsumerWidget {
  final DueDateItem item;

  const _DueDateTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue =
        !item.isDone && item.dueDate.isBefore(DateTime.now());

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.black),
      ),
      onDismissed: (_) async {
        await ref.read(dueDateProvider.notifier).remove(item.id);
      },
      child: Card(
        child: ListTile(
          title: Text(
            item.title,
            style: TextStyle(
              decoration:
                  item.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            'Due: ${item.dueDate.toLocal().toIso8601String().split('T')[0]}',
            style: TextStyle(
              color: isOverdue ? Colors.red : null,
            ),
          ),
          trailing: Icon(
            item.isDone
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
          ),
          onTap: () async {
            await ref
                .read(dueDateProvider.notifier)
                .toggleDone(item.id);
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('No due dates yet'),
          SizedBox(height: 4),
          Text(
            'Add reminders so nothing slips',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}