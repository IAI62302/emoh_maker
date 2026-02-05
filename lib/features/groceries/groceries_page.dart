import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit_family/features/groceries/presentation/grocery_notifier.dart';

class GroceriesPage extends ConsumerWidget {
  const GroceriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groceries = ref.watch(groceryProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: groceries.isEmpty
          ? const Center(
              child: Text(
                'No Groceries Yet',
                style: TextStyle(fontSize: 25),
              ),
            )
          : ListView.builder(
              itemCount: groceries.length,
              itemBuilder: (context, index) {
                final item = groceries[index];
                return ListTile(
                  leading: Checkbox(
                    value: item.isBought,
                    onChanged: (_) {
                      ref
                          .read(groceryProvider.notifier)
                          .toggleItem(item.id);
                    },
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      decoration: item.isBought
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      ref
                          .read(groceryProvider.notifier)
                          .removeItem(item.id);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'e.g. Milk, bread, eggs, etc.',
            ),
            onSubmitted: (_) => _submit(context, ref, controller),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _submit(context, ref, controller),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _submit(
    BuildContext context,
    WidgetRef ref,
    TextEditingController controller,
  ) {
    ref.read(groceryProvider.notifier).addItem(controller.text);
    Navigator.pop(context);
  }
}