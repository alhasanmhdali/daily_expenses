import 'package:flutter/cupertino.dart';
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
  bool _showChart = false;

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

  void _handleUpdateTransaction(int txId, String txTitle, double txAmount, DateTime txDate) {
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
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final AppBar appBar = AppBar(
      title: Text('Daily Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _showAddTransaction(context),
        ),
      ],
    );
    final windowSize = {
      'height': mediaQuery.size.height -
          appBar.preferredSize.height -
          mediaQuery.padding.top,
      'width': mediaQuery.size.width,
    };
    Widget txListWidget(double ratio) {
      return Container(
        height: windowSize['height'] * ratio,
        child: TransactionList(_transactions, _txDelete, _txModify),
      );
    }

    Widget chartBarWidget(double ratio) {
      return Container(
        height: windowSize['height'] * ratio,
        child: Chart(_transactions),
      );
    }

    final switchWidget = Container(
      height: windowSize['height'] * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart: '),
          Switch(
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = value;
              });
            },
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: isLandscape
            ? Column(
                children: [
                  switchWidget,
                  _showChart ? chartBarWidget(0.8) : txListWidget(0.8),
                ],
              )
            : Column(
                children: <Widget>[
                  chartBarWidget(0.3),
                  txListWidget(0.7),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => _showAddTransaction(context),
      ),
    );
  }
}
