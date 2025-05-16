import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';
import 'models/income.dart';
import 'models/category.dart';

const Color primarySeed = Color(0xFF4CAF50); // ✅ Define at the top

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(IncomeAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<Expense>('expensesBox');
  await Hive.openBox<Income>('incomeBox');
  await Hive.openBox<Category>('categoriesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KwartaKo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primarySeed),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}
