import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime date;

  Expense({
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });
}
