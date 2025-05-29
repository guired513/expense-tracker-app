import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';
import '../models/expense.dart';



class AddEntryForm extends StatefulWidget {
  final List<String> expenseCategories;
  final List<String> incomeCategories;

  const AddEntryForm({
    Key? key,
    required this.expenseCategories,
    required this.incomeCategories,
  }) : super(key: key);

  @override
  State<AddEntryForm> createState() => _AddEntryFormState();
}


class _AddEntryFormState extends State<AddEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _selectedCategory;
  bool _isIncome = false;

  @override
  Widget build(BuildContext context) {
    final categories = _isIncome ? widget.incomeCategories : widget.expenseCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isIncome ? 'Add Income' : 'Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Is this Income?'),
                  Switch(
                    value: _isIncome,
                    onChanged: (val) => setState(() => _isIncome = val),
                  ),
                ],
              ),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (val) => val == null || val.isEmpty ? 'Enter description' : null,
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (val) => val == null || val.isEmpty ? 'Enter amount' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                validator: (val) => val == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                child: Text('Save Entry'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final amount = double.tryParse(_amountController.text) ?? 0.0;
                    final category = _selectedCategory!;
                    final desc = _descController.text;
                    final entry = _isIncome
                        ? Income(
                            amount: amount,
                            categoryName: category,
                            date: DateTime.now(),
                          )
                        : Expense(
                            description: desc,
                            amount: amount,
                            categoryName: category,
                            date: DateTime.now(),
                          );
                    Navigator.pop(context, entry);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

