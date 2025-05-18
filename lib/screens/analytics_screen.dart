import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../widgets/category_budget_tile.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryBox = Hive.box<Category>('categoriesBox');
    final expenseBox = Hive.box<Expense>('expensesBox');

    // Group total expenses per category
    Map<String, double> totals = {};
    for (final e in expenseBox.values) {
      totals[e.categoryName] = (totals[e.categoryName] ?? 0) + e.amount;
    }

    final categories = categoryBox.values.where((c) => c.type == 'expense').toList();

    return Scaffold(
      appBar: AppBar(title: Text('Analytics & Budgets')),
      body: ListView(
        children: categories.map((cat) {
          return CategoryBudgetTile(
            categoryName: cat.categoryName,
            totalSpent: totals[cat.categoryName] ?? 0,
            budgetLimit: cat.budgetLimit,
            color: cat.color,
          );
        }).toList(),
      ),
    );
  }
}
