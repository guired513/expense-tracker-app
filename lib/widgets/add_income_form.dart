import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddIncomeForm extends StatefulWidget {
  @override
  State<AddIncomeForm> createState() => _AddIncomeFormState();
}

class _AddIncomeFormState extends State<AddIncomeForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _sourceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'amount': double.parse(_amountController.text),
        'source': _sourceController.text,
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
            TextFormField(
              controller: _sourceController,
              decoration: InputDecoration(labelText: 'Source (e.g. Salary)'),
              validator: (val) => val!.isEmpty ? 'Enter source' : null,
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
