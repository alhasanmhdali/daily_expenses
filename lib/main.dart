import 'package:flutter/material.dart';

import './models/transaction.dart';
import './models/myTheme.dart';
import './widgets/transaction_list.dart';
import './widgets/newTransaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _appName = 'Daily Expenses';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appName,
      theme: MyTheme().getTheme(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static int _transactionId = 0;

  final List<Transaction> _transactions = [];

  void _showAddTransaction(BuildContext ctx, [Transaction modified]) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (ctx) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: modified == null
              ? NewTransaction(_handleNewTransaction)
              : NewTransaction(_handleUpdateTransaction, modified),
        );
      },
    );
  }

  void _handleNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    setState(() {
      _transactions.add(Transaction(
        id: _transactionId++,
        title: txTitle,
        amount: txAmount,
        date: txDate,
      ));
      print(_transactionId);
    });
  }

  void _handleUpdateTransaction(
      int txId, String txTitle, double txAmount, DateTime txDate) {
    setState(() {
      _transactions
          .elementAt(_transactions.indexWhere((tx) => tx.id == txId))
          .updateTransaction(txTitle, txAmount, txDate);
    });
  }

  void _txModify(int txId) {
    _showAddTransaction(
        context,
        _transactions
            .elementAt(_transactions.indexWhere((tx) => tx.id == txId)));
  }

  void _txDelete(int txId) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == txId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Expenses'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTransaction(context),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Chart(_transactions),
          TransactionList(_transactions, _txDelete, _txModify),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => _showAddTransaction(context),
      ),
    );
  }
}
