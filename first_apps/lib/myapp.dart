import 'package:first_apps/TransactionList.dart';
import 'package:first_apps/transaction.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _contentController = TextEditingController();
  final _amountController = TextEditingController();
  Transaction transaction = Transaction(content: '', amount: 0.0);
  List<Transaction> _transactions = List<Transaction>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _insertTransaction() {
    if (transaction.content.isEmpty ||
        transaction.amount.isNaN ||
        transaction.amount == 0.0) return;

    transaction.createdDate = DateTime.now();
    _transactions.add(transaction);
    transaction = Transaction(content: '', amount: 0.0);
    _contentController.text = '';
    _amountController.text = '';
  }

  void _onButtonShowModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(labelText: 'Content'),
                    onChanged: (text) {
                      setState(() {
                        transaction.content = text;
                      });
                    },
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount(money)'),
                    onChanged: (text) {
                      setState(() {
                        transaction.amount = double.tryParse(text) ?? 0;
                      });
                    },
                  )),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                      height: 50,
                      child: RaisedButton(
                          color: Colors.teal,
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () {
                            setState(() {
                              this._insertTransaction();
                              Navigator.of(context).pop();
                            });
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(_transactions.toString()),
                              duration: Duration(seconds: 1),
                            ));
                          }),
                    )),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Expanded(
                        child: SizedBox(
                      height: 50,
                      child: RaisedButton(
                          color: Colors.pinkAccent,
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () {
                            print('cancel button pressed');
                            Navigator.of(context).pop();
                          }),
                    ))
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Manager'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _onButtonShowModalSheet();
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add transaction',
          child: Icon(Icons.add),
          onPressed: () {
            _onButtonShowModalSheet();
          },
          backgroundColor: Theme.of(context).primaryColor,
        ),
        key: _scaffoldKey,
        body: SafeArea(
            minimum: EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10)),
                  ButtonTheme(
                    height: 50,
                    child: FlatButton(
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Insert Transaction',
                          style:
                              TextStyle(fontSize: 18, fontFamily: 'Pacifico'),
                        ),
                        onPressed: () {
                          _onButtonShowModalSheet();
                        }),
                  ),
                  TransactionList(transactions: _transactions)
                ],
              ),
            )));
  }
}
