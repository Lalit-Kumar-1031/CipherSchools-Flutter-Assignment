import 'package:hive/hive.dart';

part 'transaction.g.dart';  // This file is generated by Hive generator

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final double amount;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final bool isExpense;
  @HiveField(5)
  final String key;// true for expense, false for income

  Transaction({
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
    required this.isExpense,
    required this.key
  });
}