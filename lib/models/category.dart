import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final Color color;

  @HiveField(2)
  final IconData icon;

  @HiveField(3)
  final double? budgetLimit;

  @HiveField(4)
  final String type; // "income" or "expense"

  Category({
    required this.name,
    required this.color,
    required this.icon,
    this.budgetLimit,
    required this.type,
  });
}
