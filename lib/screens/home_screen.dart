import 'package:flutter/material.dart';
import '../widgets/add_expense_form.dart';
import '../widgets/expense_tile.dart';
import '../models/expense.dart';



class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];

  void _openAddExpenseSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
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

    if (result != null) {
      setState(() {
        _expenses.add(
          Expense(
            amount: result['amount'],
            category: result['category'],
            description: result['description'],
            date: result['date'],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        centerTitle: true,
      ),
      body: _expenses.isEmpty
          ? Center(
              child: Text(
                'No expenses yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (ctx, i) => ExpenseTile(expense: _expenses[i]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseSheet,
        child: Icon(Icons.add),
      ),
    );
  }
}