import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';
import '../models/expense.dart';
class AddEntryForm extends StatefulWidget {
  const AddEntryForm({super.key});

  @override
  _AddEntryFormState createState() => _AddEntryFormState();
}



class _AddEntryFormState extends State<AddEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();


  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = ['Food', 'Transport', 'Bills', 'Shopping', 'Others'];

  late Box<Category> _categoryBox;
  List<Category> _expenseCategories = [];
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _categoryBox = Hive.box<Category>('categoriesBox');
    _expenseCategories = _categoryBox.values
        .where((c) => c.type == 'expense')
        .toList();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final expense = {
        'amount': double.parse(_amountController.text),
        'description': _descController.text,
        'category': _selectedCategory!.name,
        'date': _selectedDate,
      };

      Navigator.pop<Map<String, dynamic>>(context, expense);
    }
  }

  void _presentDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16,
          children: [
            Text(
              'Add Expense',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
              validator: (value) => value!.isEmpty ? 'Enter amount' : null,
            ),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: 'Category'),
              items: _expenseCategories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
              validator: (val) => val == null ? 'Select a category' : null,
            ),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) => value!.isEmpty ? 'Enter description' : null,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text('Change Date'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: Text('Cancel'),
                ),
                ElevatedButton(onPressed: _submitForm, child: Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

