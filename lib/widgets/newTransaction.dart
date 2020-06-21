import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class NewTransaction extends StatefulWidget {
  final Function handler;
  final Transaction modTx;

  NewTransaction(this.handler, [this.modTx]);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  bool fetched = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  DateTime _txDate = DateTime.now();

  void _init() {
    _titleController = TextEditingController(text: widget.modTx.title);
    _amountController =
        TextEditingController(text: widget.modTx.amount.toString());
    _txDate = widget.modTx.date;
  }

  void _submitTx() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    fetched
        ? widget.handler(widget.modTx.id, enteredTitle, enteredAmount, _txDate)
        : widget.handler(enteredTitle, enteredAmount, _txDate);

    Navigator.of(context).pop();
  }

  void _pickDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      setState(() {
        _txDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.modTx != null && !fetched) {
      _init();
      fetched = true;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets.add(EdgeInsets.all(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                'Add a new transaction'.toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 30,
              thickness: 3,
            ),
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            Row(
              children: <Widget>[
                Text(DateFormat.yMMMEd().format(_txDate)),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Choose Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _pickDate,
                ),
              ],
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
              child: Text('Add Transaction'),
              onPressed: _submitTx,
            )
          ],
        ),
      ),
    );
  }
}
