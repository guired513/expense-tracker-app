import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense.dart';
import '../models/income.dart';
import '../widgets/add_expense_form.dart';
import '../widgets/add_income_form.dart';
import '../widgets/expense_tile.dart';
import 'category_screen.dart';
import 'package:kwartako/screens/chart_screen.dart';
import 'package:kwartako/screens/settings_screen.dart';


int _selectedIndex = 0;



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategoryFilter;
  late Box<Expense> _expenseBox;
  late Box<Income> _incomeBox;
  DateTime? _selectedDate;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _expenseBox = Hive.box<Expense>('expensesBox');
    _incomeBox = Hive.box<Income>('incomeBox');
  }
  List<String> get _availableCategories => _allCategories;
  List<Expense> get _expenses => _expenseBox.values.toList();
  List<Expense> get _filteredExpenses {
    List<Expense> list = _expenses;
    if (_selectedCategory != 'All') {
      list = list.where((e) => e.categoryName == _selectedCategory).toList();
    }
    if (_selectedDate != null) {
      list = list.where((e) =>
        e.date.year == _selectedDate!.year &&
        e.date.month == _selectedDate!.month &&
        e.date.day == _selectedDate!.day
      ).toList();
    }
    return list;
  }

  List<String> get _allCategories => ['All', ..._expenses.map((e) => e.categoryName).toSet()];

  void _openAddExpenseSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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

  void _openAddIncomeSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AddIncomeForm(),
      ),
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
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _resetDateFilter() {
    setState(() {
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                tooltip: 'Pick Date',
                onPressed: _pickDate,
              ),
              if (_selectedDate != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear Date Filter',
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                _buildSummaryCard(
                  icon: Icons.arrow_upward,
                  label: 'Income',
                  amount: _calculateTotal(_incomeBox),
                  color: Colors.green,
                ),
                _buildSummaryCard(
                  icon: Icons.arrow_downward,
                  label: 'Spent',
                  amount: _calculateTotal(_expenseBox),
                  color: Colors.red,
                ),
                _buildSummaryCard(
                  icon: Icons.account_balance_wallet,
                  label: 'Balance',
                  amount: _calculateTotal(_incomeBox) - _calculateTotal(_expenseBox),
                  color: Colors.teal,
                ),
              ],
            ),
          ),
          _buildFilterChips(),
          /*Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _availableCategories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final isSelected = isAll
                    ? _selectedCategoryFilter == null
                    : _selectedCategoryFilter == _availableCategories[index - 1];

                return ChoiceChip(
                  label: Text(isAll ? 'All' : _availableCategories[index - 1]),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategoryFilter = isAll ? null : _availableCategories[index - 1];
                    });
                  },
                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                );
              },
            ),
          ),*/
          Expanded(
            child: _filteredExpenses.isEmpty
              ? Center(child: Text('No expenses found.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: _filteredExpenses.length,
                  itemBuilder: (_, i) => ExpenseTile(expense: _filteredExpenses[i]),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpenseSheet,
        icon: Icon(Icons.add),
        label: Text("Add Expense"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Navigate or show modal
          switch (index) {
            case 0:
              // Home - do nothing
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CategoryScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChartScreen()),
              );
              break;
            case 3:
              // Optional: implement SettingsScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Charts'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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
          final selected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: selected,
              onSelected: (_) => setState(() => _selectedCategory = category),
              selectedColor: Colors.indigo,
              labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
  

  
  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '₱${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
  double _calculateTotal(Box box) {
    return box.values
        .whereType<dynamic>()
        .fold(0.0, (sum, item) => sum + (item.amount ?? 0));
  }



}
