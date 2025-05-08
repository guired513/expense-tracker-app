import 'package:hive/hive.dart';

part 'income.g.dart';

@HiveType(typeId: 1)
class Income {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final String source;

  @HiveField(2)
  final DateTime date;

  Income({
    required this.amount,
    required this.source,
    required this.date,
  });
}
