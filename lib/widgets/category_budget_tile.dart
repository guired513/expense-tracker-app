import 'package:flutter/material.dart';

class CategoryBudgetTile extends StatelessWidget {
  final String categoryName;
  final double totalSpent;
  final double? budgetLimit;
  final Color color;

  const CategoryBudgetTile({super.key, 
    required this.categoryName,
    required this.totalSpent,
    required this.color,
    this.budgetLimit,
  });

  @override
  Widget build(BuildContext context) {
    final overBudget = budgetLimit != null && totalSpent > budgetLimit!;
    final percent = budgetLimit != null ? (totalSpent / budgetLimit!).clamp(0.0, 1.0) : null;

    return Card(
      color: overBudget ? Colors.red[100] : Colors.green[50],
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color),
        title: Text(categoryName),
        subtitle: budgetLimit != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(overBudget ? Colors.red : Colors.green),
                  ),
                  SizedBox(height: 4),
                  Text('₱${totalSpent.toStringAsFixed(2)} of ₱${budgetLimit!.toStringAsFixed(2)}'),
                ],
              )
            : Text('Spent: ₱${totalSpent.toStringAsFixed(2)}'),
      ),
    );
  }
}
