import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/model/rekeningModel.dart';
import 'package:projek_ta/views/deposit/konfirmasiDeposit.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class DepositView extends StatefulWidget {
  @override
  _DepositViewState createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
  //data push keapi
  String _bankPilih;
  var txtNominal = TextEditingController();
  //data push keapi

  final _scaffoldState = new GlobalKey<ScaffoldState>();
  final _formState = new GlobalKey<FormState>();
  int nominal;
  var _autovalidate = false;

  _snackBarShow(String value) {
    _scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(value),
      backgroundColor: Colors.red,
      // duration: Duration(seconds: 1),
      action: SnackBarAction(
        textColor: Colors.white,
        label: "OK",
        onPressed: () {},
      ),
    ));
  }

  check() {
    final form = _formState.currentState;
    if (_bankPilih == null) {
      _snackBarShow("Silahkan pilih bank");
    } else {
      if (form.validate()) {
        setState(() {
          txtNominal.text.replaceAll(",", "");
        });
        form.save();
        _alertDialogShow();
      } else {
        setState(() {
          _autovalidate = true;
        });
      }
    }
  }

  _alertDialogShow() {
    String namaBankPilih = listRek[int.parse(_bankPilih) - 1].nama_bank;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Apakah anda yakin?"),
            content: new Text(
                "Deposit Saldo \nNominal: ${uangFormat(txtNominal.text)} \nBank: $namaBankPilih"),
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KonfirmasiDeposit(
                              txtNominal.text,
                              listRek[int.parse(_bankPilih) - 1])));
                  // Navigator.of(context).pushReplacementNamed(
                  //     '/home/deposit_view/konfirmasiDeposit');
                },
              ),
            ],
          );
        });
  }

  _pilihBank(String value) {
    setState(() {
      _bankPilih = value;
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

  uangFormat(String value) {
    final FlutterMoneyFormatter nominalTampil = FlutterMoneyFormatter(
        amount: double.parse(value),
        settings: MoneyFormatterSettings(
            symbol: 'Rp',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 0,
            compactFormatType: CompactFormatType.long));

    return nominalTampil.output.symbolOnLeft;
  }

  List<Widget> kotakNominal() {
    List<Widget> childrens = [];
    for (var i = 0; i < listWarna.length; i++) {
      childrens.add(Column(children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              // txtNominal.text = textNominal[i].toString().replaceAll(".","");
              txtNominal.text = textNominal[i];
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
          uangFormat(textNominal[i]),
          style: TextStyle(fontWeight: FontWeight.w500),
        )
      ]));
    }
    return childrens;
  }

  var loading = false;
  final listRek = new List<RekeningModel>();
  final _refresh = GlobalKey<RefreshIndicatorState>();

  Future<void> _fetchData() async {
    listRek.clear();
    setState(() {
      //saat masih dalam proses mencari loadingnya jalan
      loading = true;
    });
    final response = await http.get(BaseUrl.rekening);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      data['data_rekening'].forEach((api) {
        final dataAPI = new RekeningModel(api['id_rek_bank'], api['nama_bank'],
            api['atas_nama_rek'], api['no_rek'], api['logo_bank']);
        listRek.add(dataAPI);
      });

      print("berhasil");
    } else {
      print("gagal");
    }

    setState(() {
      //saat data sudah dapat loadingnya stop
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      floatingActionButton: loading
          ? Center()
          : Padding(
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
      body: RefreshIndicator(
        onRefresh: _fetchData,
        key: _refresh,
        child: loading
            ? ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Center(child: CircularProgressIndicator()))
                ],
              )
            : ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  Form(
                    key: _formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "ISI NOMINAL",
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                        TextFormField(
                          controller: txtNominal,
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
                          children: kotakNominal(),
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
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: listRek.length,
                          itemBuilder: (context, i) {
                            final item = listRek[i];
                            return ListTile(
                              leading: Icon(Icons.account_balance),
                              title: Text("Transfer ${item.nama_bank}"),
                              subtitle: Text("a/n ${item.atas_nama_rek}"),
                              trailing: Radio(
                                value: item.id_rek_bank,
                                groupValue: _bankPilih,
                                onChanged: (value) {
                                  _pilihBank(value);
                                  print(_bankPilih);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
