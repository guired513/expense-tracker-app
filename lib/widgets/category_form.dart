import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CategoryForm extends StatefulWidget {
  final Function(String name, String type, Color color, IconData icon, double? budget) onSubmit;

  const CategoryForm({super.key, required this.onSubmit});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();

  String _selectedType = 'expense';
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.shopping_cart;

  final List<IconData> _iconOptions = [
    Icons.shopping_cart,
    Icons.food_bank,
    Icons.attach_money,
    Icons.flight,
    Icons.home,
    Icons.car_rental,
    Icons.school,
    Icons.healing,
  ];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final type = _selectedType;
      final color = _selectedColor;
      final icon = _selectedIcon;
      final budget = _budgetController.text.isNotEmpty ? double.tryParse(_budgetController.text) : null;

      widget.onSubmit(name, type, color, icon, budget);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16,
          children: [
            Text('New Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Category Name'),
              validator: (val) => val!.isEmpty ? 'Enter name' : null,
            ),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(labelText: 'Type'),
              items: ['expense', 'income']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type.capitalize())))
                  .toList(),
              onChanged: (val) => setState(() => _selectedType = val!),
            ),
            TextFormField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Budget Limit (Optional)'),
            ),
            Row(
              children: [
                Text('Color:'),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    final newColor = await showDialog<Color>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Pick a color'),
                        content: Wrap(
                          spacing: 10,
                          children: Colors.primaries
                              .map((c) => GestureDetector(
                                    onTap: () => Navigator.pop(context, c),
                                    child: CircleAvatar(backgroundColor: c),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                    if (newColor != null) setState(() => _selectedColor = newColor);
                  },
                  child: CircleAvatar(backgroundColor: _selectedColor),
                ),
              ],
            ),
            Wrap(
              spacing: 10,
              children: _iconOptions.map((icon) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: CircleAvatar(
                    backgroundColor: _selectedIcon == icon ? Colors.indigo : Colors.grey,
                    child: Icon(icon, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(onPressed: _submit, child: Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
