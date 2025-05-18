import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/income.dart';

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
  bool _isIncome = false;
  String _description = '';
  double _amount = 0.0;
  String? _selectedCategory;
  late final List<String> expenseCategories;
  late final List<String> incomeCategories; 

  late List<String> categories;
  late String entryType;

  
  


  @override
  void initState() {
    super.initState();
    expenseCategories = widget.expenseCategories;
    incomeCategories = widget.incomeCategories;
    categories = _isIncome ? widget.incomeCategories : widget.expenseCategories;
    entryType = _isIncome ? "Income" : "Expense";
  }
  
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
              SwitchListTile(
                title: Text('Is this Income?'),
                value: _isIncome,
                onChanged: (val) => setState(() => _isIncome = val),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (val) => val == null || val.isEmpty ? 'Enter description' : null,
                onSaved: (val) => _description = val!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || double.tryParse(val) == null
                    ? 'Enter a valid amount'
                    : null,
                onSaved: (val) => _amount = double.parse(val!),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Category'),
                value: _selectedCategory,
                items: (_isIncome ? widget.incomeCategories : widget.expenseCategories)
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                validator: (val) => val == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                child: const Text('Save Entry'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final now = DateTime.now();

                    final entry = _isIncome
                        ? Income(amount: _amount, categoryName: _selectedCategory!, date: now)
                        : Expense(
                            description: _description,
                            amount: _amount,
                            categoryName: _selectedCategory!,
                            date: now,
                          );

                    Navigator.pop(context, entry);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}