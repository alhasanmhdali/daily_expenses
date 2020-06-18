import 'package:flutter/foundation.dart';

class Transaction {
  int id;
  String title;
  double amount;
  DateTime date;

  Transaction(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.date});

  void updateTransaction(String newTitle, double newAmount, DateTime newDate) {
    this.title = newTitle;
    this.amount = newAmount;
    this.date = newDate;
  }
}
