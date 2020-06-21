import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _myTransactions;
  final Function _delete;
  final Function _modify;

  TransactionList(this._myTransactions, this._delete, this._modify);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _myTransactions.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: <Widget>[
                    Text(
                      'There is no transactions yet!',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        height: constraints.maxHeight * 0.5,
                        child: Image.asset(
                          'assets/img/waiting.png',
                          fit: BoxFit.fill,
                        )),
                  ],
                );
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _myTransactions.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        child: Text('\$${_myTransactions[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    _myTransactions[index].title,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline1,
                  ),
                  subtitle: Text(
                      DateFormat.yMd().format(_myTransactions[index].date)),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _modify(_myTransactions[index].id),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _delete(_myTransactions[index].id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
