import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';

class AddIncomeForm extends StatefulWidget {
  const AddIncomeForm({super.key});

  @override
  State<AddIncomeForm> createState() => _AddIncomeFormState();
}

class _AddIncomeFormState extends State<AddIncomeForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _sourceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  late Box<Category> _categoryBox;
  List<Category> _incomeCategories = [];
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _categoryBox = Hive.box<Category>('categoriesBox');
    _incomeCategories = _categoryBox.values
        .where((c) => c.type == 'income')
        .toList();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'amount': double.parse(_amountController.text),
        'category': _selectedCategory!.name,
        'date': _selectedDate,
      });
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
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
            Text('Add Income', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
              validator: (val) => val!.isEmpty ? 'Enter amount' : null,
            ),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: 'Category'),
              items: _incomeCategories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
              validator: (val) => val == null ? 'Select a category' : null,
            ),
            Row(
              children: [
                Expanded(child: Text('Date: ${DateFormat.yMMMd().format(_selectedDate)}')),
                TextButton(onPressed: _pickDate, child: Text('Change')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                ElevatedButton(onPressed: _submit, child: Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
