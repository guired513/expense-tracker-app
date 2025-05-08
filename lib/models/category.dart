import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int colorValue; // store color as int

  @HiveField(2)
  final int iconCodePoint; // store icon code point

  @HiveField(3)
  final String iconFontFamily; // store icon font family

  @HiveField(4)
  final double? budgetLimit;

  @HiveField(5)
  final String type;

  Category({
    required this.name,
    required this.colorValue,
    required this.iconCodePoint,
    required this.iconFontFamily,
    this.budgetLimit,
    required this.type,
  });

  Color get color => Color(colorValue);

  IconData get icon => IconData(iconCodePoint, fontFamily: iconFontFamily);
}
