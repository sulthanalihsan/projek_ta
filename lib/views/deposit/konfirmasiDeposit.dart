import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/model/depositModel.dart';
import 'package:projek_ta/model/rekeningModel.dart';
import 'package:projek_ta/views/deposit/detailTagihan.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';

class KonfirmasiDeposit extends StatefulWidget {
  final String nominal;
  final RekeningModel rekening;

  KonfirmasiDeposit(this.nominal, this.rekening);

  @override
  _KonfirmasiDepositState createState() => _KonfirmasiDepositState();
}

class _KonfirmasiDepositState extends State<KonfirmasiDeposit> {
  String idPlg;
  final Color warnaPrimary = Color.fromARGB(255, 116, 150, 213);
  final TextStyle styleJudul = TextStyle(
      color: Color.fromARGB(255, 116, 150, 213), fontWeight: FontWeight.bold);

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idPlg = preferences.getString("idPlg");
    });
  }

  DepositModel lastDeposit;
  getLastDeposit() async {
    var queryParameters = {'id_plg': idPlg};
    var uri = Uri.parse(BaseUrl.lastDeposit)
        .replace(queryParameters: queryParameters)
        .toString();
    // final response = await http.get(BaseUrl.rekening);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(uri, headers: requestHeaders);
    final data = jsonDecode(response.body);
    final data_deposit = data['data_deposit'];

    print("DATA ID LAST DEPOSIT");
    print(data_deposit['id_deposit']);
    if (response.statusCode == 200) {
      final temp = new DepositModel(
          data_deposit['id_deposit'],
          data_deposit['id_plg'],
          data_deposit['id_rek_bank'],
          data_deposit['id_status'],
          data_deposit['jml_deposit'],
          data_deposit['waktu_deposit'],
          data_deposit['kode_unik']);
      setState(() {
        lastDeposit = temp;
      });
    }
    berhasilMembuatTagihan();
  }

  var loading = false;
  postData() async {
    final response = await http.post(BaseUrl.deposit, body: {
      'id_plg': idPlg,
      'id_rek_bank': widget.rekening.id_rek_bank,
      'jml_deposit': widget.nominal
    });

    final data = jsonDecode(response.body);
    final status = data['status'];
    final pesan = data['message'];
    if (status == 1) {
      print(pesan);
      // Navigator.pop(context);
      getLastDeposit();
      // _onLoadingBerhasil();
    } else {
      print(pesan);
      gagalMembuatTagihan();
    }
  }

  void berhasilMembuatTagihan() {
    showSimpleNotification(
        context, Text("Tagihan berhasil dibuat silahkan lakukan transfer"),
        background: Colors.green);
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailTagihan(lastDeposit, widget.rekening, true)),
        ModalRoute.withName(Navigator.defaultRouteName));
  }

  void gagalMembuatTagihan() {
    Navigator.pop(context);
    showSimpleNotification(context, Text("Gagal"), background: Colors.red);
  }

  void loadingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height / 4,
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text("Loading...")
                ],
              ),
            ),
          );
        });

    postData();
  }

  _alertDialogShow() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Apakah anda yakin?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Batal"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("Konfirmasi"),
                onPressed: () {
                  Navigator.pop(context);
                  loadingDialog();
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    final FlutterMoneyFormatter nominalTampil = FlutterMoneyFormatter(
        amount: double.parse(widget.nominal),
        settings: MoneyFormatterSettings(
            symbol: 'Rp',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 2,
            compactFormatType: CompactFormatType.long));

    var format = new DateFormat('d MMMM yyyy');
    var tglSekarang = format.format(new DateTime.now());
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: screenSize.width / 2.3,
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey,
                    child: Text(
                      "BATAL",
                      textAlign: TextAlign.center,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: screenSize.width / 2.3,
                  child: FloatingActionButton(
                    child: Text(
                      "KONFIRMASI",
                      textAlign: TextAlign.center,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    onPressed: () {
                      _alertDialogShow();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("Konfirmasi Deposit"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Tanggal Transaksi",
                    style: styleJudul,
                  ),
                  Text(tglSekarang)
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Nominal Deposit",
                    style: styleJudul,
                  ),
                  Text("${nominalTampil.output.symbolOnLeft}")
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Tujuan Rekening",
                    style: styleJudul,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Bank"),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text("Atas Nama"),
                          ),
                          Text("No. Rek")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(":"),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(":"),
                          ),
                          Text(":")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("${widget.rekening.nama_bank}"),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text("${widget.rekening.atas_nama_rek}"),
                          ),
                          Text("${widget.rekening.no_rek}")
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
