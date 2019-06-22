import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as prefix0;
import 'package:projek_ta/custom/currency.dart';
import 'package:projek_ta/views/deposit/konfirmasiDeposit.dart';

class DepositView extends StatefulWidget {
  @override
  _DepositViewState createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
  final _scaffoldState = new GlobalKey<ScaffoldState>();
  final _formState = new GlobalKey<FormState>();
  int nominal, _bank;
  var _autovalidate = false;
  var txt = TextEditingController();

  _snackBarShow() {
    _scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text("Nominal: ${txt.text}, Bank: ${_bank}"),
      // duration: Duration(seconds: 1),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
      ),
    ));
  }

  check() {
    final form = _formState.currentState;
    if (form.validate()) {
      setState(() {
        txt.text.replaceAll(",", "");
      });
      form.save();
      _alertDialogShow();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  _alertDialogShow() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Apakah anda yakin?"),
            content: new Text(
                "Deposit saldo \nNominal: Rp. ${txt.text} \nBank: $_bank"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("Yakin"),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed('/home/deposit_view/konfirmasiDeposit');
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => KonfirmasiDeposit()));
                },
              ),
            ],
          );
        });
  }

  _pilihBank(int value) {
    setState(() {
      _bank = value;
    });
  }

  List<Color> listWarna = [
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.orange
  ];
  List textNominal = [
    '25000',
    '55000',
    '75000',
    '100000',
  ];

  List<Widget> anu() {
    List<Widget> childrens = [];
    for (var i = 0; i < listWarna.length; i++) {
      childrens.add(Column(children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              // txt.text = textNominal[i].toString().replaceAll(".","");
              txt.text = textNominal[i];
            });
          },
          child: Card(
            color: listWarna[i],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              width: 60.0,
              height: 60.0,
              child: Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 3.5,
        ),
        Text(
          "Rp" + textNominal[i],
          style: TextStyle(fontWeight: FontWeight.w500),
        )
      ]));
    }
    return childrens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FloatingActionButton(
              child: Text("LANJUTKAN PEMBAYARAN"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              onPressed: () {
                // _snackBarShow();
                // _alertDialogShow();
                check();
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("Deposit Saldo"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "ISI NOMINAL",
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
              TextFormField(
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  CurrencyFormat()
                ],
                controller: txt,
                keyboardType: TextInputType.number,
                onSaved: (e) => nominal = int.parse(e),
                autovalidate: _autovalidate,
                validator: (e) {
                  if (e.isEmpty) {
                    return "Masukkan Nominal";
                  }
                },
                decoration: InputDecoration(prefix: Text("Rp")),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: anu(),
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                "PILIH BANK PEMBAYARAN",
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
              SizedBox(
                height: 5.0,
              ),
              ListTile(
                leading: Icon(Icons.account_balance),
                title: Text("Transfer Bank BCA"),
                subtitle: Text('a/n Muhammad Sulthan Al ihsan'),
                trailing: Radio(
                  value: 1,
                  groupValue: _bank,
                  onChanged: (int value) {
                    _pilihBank(value);
                  },
                ),
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.account_balance),
                ),
                title: Text("Transfer Bank BRI"),
                subtitle: Text('a/n Muhammad Sulthan Al ihsan'),
                trailing: Radio(
                  value: 2,
                  groupValue: _bank,
                  onChanged: (int value) {
                    _pilihBank(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
