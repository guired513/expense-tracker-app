import 'package:flutter/material.dart';
import '../widgets/add_expense_form.dart';
import '../widgets/expense_tile.dart';
import '../models/expense.dart';
import '../widgets/summary_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/income.dart';
import '../widgets/add_income_form.dart';
import 'package:expense_tracker_app/screens/category_screen.dart';



class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Expense> _expenseBox;
  late Box<Income> _incomeBox;
  @override
  void initState() {
    super.initState();
    _expenseBox = Hive.box<Expense>('expensesBox');
    _incomeBox = Hive.box<Income>('incomeBox');
  }
  List<Expense> get _expenses => _expenseBox.values.toList();
  String _selectedCategory = 'All';

  List<String> get _allCategories {
    return ['All', ..._expenses.map((e) => e.categoryName).toSet()];
  }
  List<Expense> get _filteredExpenses {
    if (_selectedCategory == 'All') return _expenses;
    return _expenses.where((e) => e.categoryName == _selectedCategory).toList();
  }

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
        _expenseBox.add(
          Expense(
            amount: result['amount'],
            categoryName: result['category'],
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
         actions: [
          IconButton(
            icon: Icon(Icons.attach_money),
            onPressed: () async {
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (_) => AddIncomeForm(),
              );

              if (result != null) {
                setState(() {
                  _incomeBox.add(
                    Income(
                      amount: result['amount'],
                      categoryName: result['category'],
                      date: result['date'],
                    ),
                  );
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CategoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCards(),
          _buildFilterChips(),
          Expanded(
            child: _filteredExpenses.isEmpty
                ? Center(
                    child: Text(
                      'No expenses found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredExpenses.length,
                    itemBuilder: (ctx, i) => ExpenseTile(expense: _filteredExpenses[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseSheet,
        child: Icon(Icons.add),
      ),
     
    );
  }
  Widget _buildSummaryCards() {
  if (_expenses.isEmpty && _incomeBox.isEmpty) return SizedBox.shrink();

    double expenseTotal = _expenses.fold(0.0, (sum, e) => sum + e.amount);
    double incomeTotal = _incomeBox.values.fold(0.0, (sum, i) => sum + i.amount);
    double balance = incomeTotal - expenseTotal;

    Map<String, double> categoryTotals = {};
    Expense? biggest;

    for (var e in _expenses) {
      categoryTotals[e.categoryName] = (categoryTotals[e.categoryName] ?? 0) + e.amount;
      if (biggest == null || e.amount > biggest.amount) {
        biggest = e;
      }
    }

    String topCategory = categoryTotals.isNotEmpty
        ? categoryTotals.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'N/A';

    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SummaryCard(
            title: 'Income',
            value: '₱${incomeTotal.toStringAsFixed(2)}',
            icon: Icons.download,
            color: Colors.green,
          ),
          SummaryCard(
            title: 'Total Spent',
            value: '₱${expenseTotal.toStringAsFixed(2)}',
            icon: Icons.savings,
          ),
          SummaryCard(
            title: 'Balance',
            value: '₱${balance.toStringAsFixed(2)}',
            icon: Icons.account_balance_wallet,
            color: balance >= 0 ? Colors.green : Colors.red,
          ),
          SummaryCard(
            title: 'Top Category',
            value: topCategory,
            icon: Icons.category,
            color: Colors.orange,
          ),
          if (biggest != null)
            SummaryCard(
              title: 'Biggest Expense',
              value: '₱${biggest.amount.toStringAsFixed(2)}',
              icon: Icons.trending_up,
              color: Colors.red,
            ),
        ],
      ),
    );
  }


  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: _allCategories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: Colors.indigo,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }



}