import 'package:flutter/material.dart';

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
          // Will open add-expense dialog in next phase
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
