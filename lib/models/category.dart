import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  late String categoryName;

  @HiveField(1)
  late String type; // "Income" or "Expense"

  @HiveField(2)
  final int colorValue; // store color as int

  @HiveField(3)
  final int iconCodePoint; // store icon code point

  @HiveField(4)
  final String iconFontFamily; // store icon font family

  @HiveField(5)
  final double? budgetLimit;



  Category({
    required this.categoryName,
    required this.type,
    required this.colorValue,
    required this.iconCodePoint,
    required this.iconFontFamily,
    this.budgetLimit,
  });

  Color get color => Color(colorValue);

  IconData get icon => IconData(iconCodePoint, fontFamily: iconFontFamily);
}
