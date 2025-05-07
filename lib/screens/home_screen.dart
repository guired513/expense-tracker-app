import 'package:flutter/material.dart';
import '../widgets/add_expense_form.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'No expenses yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AddExpenseForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
