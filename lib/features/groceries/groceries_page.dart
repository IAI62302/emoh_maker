import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit_family/features/groceries/presentation/grocery_notifier.dart';
import 'package:planit_family/features/groceries/domain/grocery_item.dart';

class GroceriesPage extends ConsumerWidget {
  const GroceriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(groceryProvider);

    final toBuy = items.where((e) => !e.isBought).toList();
    final bought = items.where((e) => e.isBought).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: items.isEmpty
          ? _EmptyState()
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                if (toBuy.isNotEmpty)
                  _Section(
                    title: 'To Buy',
                    items: toBuy,
                  ),
                if (bought.isNotEmpty)
                  _Section(
                    title: 'Bought',
                    items: bought,
                  ),
              ],
            ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Grocery Item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Milk, Eggs, Bread…',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _submit(ref, controller, context),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submit(ref, controller, context),
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(
    WidgetRef ref,
    TextEditingController controller,
    BuildContext context,
  ) async {
    await ref.read(groceryProvider.notifier).addItem(controller.text);
    Navigator.pop(context);
}
}

class _Section extends ConsumerWidget {
  final String title;
  final List<GroceryItem> items;

  const _Section({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => _GroceryTile(item: item),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _GroceryTile extends ConsumerWidget {
  final GroceryItem item;

  const _GroceryTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red.withOpacity(0.8),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        ref.read(groceryProvider.notifier).remove(item.id);
      },
      child: Card(
        child: ListTile(
          title: Text(
            item.title,
            style: TextStyle(
              decoration:
                  item.isBought ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: Icon(
            item.isBought
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
          ),
          onTap: () async {
            ref.read(groceryProvider.notifier).toggle(item.id);
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No groceries yet',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 4),
          Text(
            'Add items to start your list',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}