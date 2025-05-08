import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';
import '../widgets/category_form.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Box<Category> _categoryBox;

  @override
  void initState() {
    super.initState();
    _categoryBox = Hive.box<Category>('categoriesBox');
  }

  void _addCategory(String name, String type, Color color, IconData icon, double? budget) {
    final newCategory = Category(
      name: name,
      colorValue: color.value,
      iconCodePoint: icon.codePoint,
      iconFontFamily: icon.fontFamily ?? 'MaterialIcons',
      budgetLimit: budget,
      type: type,
    );

    setState(() {
      _categoryBox.add(newCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Categories')),
      body: ValueListenableBuilder(
        valueListenable: _categoryBox.listenable(),
        builder: (context, Box<Category> box, _) {
          final categories = box.values.toList();

          if (categories.isEmpty) {
            return Center(child: Text('No categories yet.'));
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (ctx, i) {
              final c = categories[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: c.color,
                  child: Icon(c.icon, color: Colors.white),
                ),
                title: Text(c.name),
                subtitle: Text('${c.type.capitalize()}'
                    '${c.budgetLimit != null ? ' • Budget: ₱${c.budgetLimit!.toStringAsFixed(2)}' : ''}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => CategoryForm(onSubmit: _addCategory),
          );
        },
      ),
    );
  }
}
extension StringCasingExtension on String {
  String capitalize() => this.isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
}
