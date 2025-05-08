import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;

  const ExpenseTile({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo,
          child: Text(
            expense.categoryName[0],
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text('₱${expense.amount.toStringAsFixed(2)} - ${expense.categoryName}'),
        subtitle: Text(expense.description),
        trailing: Text(DateFormat.yMMMd().format(expense.date)),
      ),
    );
  }
}
