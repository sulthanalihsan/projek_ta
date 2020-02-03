// import 'dart:_http';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/model/depositModel.dart';
import 'package:projek_ta/model/rekeningModel.dart';
import 'package:projek_ta/views/deposit/riwayatDeposit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class DetailTagihan extends StatefulWidget {
  // final String idDeposit;
  final DepositModel detailDepositModel;
  final RekeningModel rekeningModel;
  final bool showButton;

  DetailTagihan(this.detailDepositModel, this.rekeningModel, this.showButton);

  @override
  _DetailTagihanState createState() => _DetailTagihanState();
}

class _DetailTagihanState extends State<DetailTagihan> {
  String idPlg,
      nominalTagihan,
      kodeUnik,
      totalTagihan,
      tglTransaksi,
      wktTransaksi;
  int total;

  final Color warnaPrimary = Color.fromARGB(255, 116, 150, 213);
  final TextStyle styleJudul = TextStyle(
      color: Color.fromARGB(255, 116, 150, 213), fontWeight: FontWeight.bold);
  final _keyScaffold = new GlobalKey<ScaffoldState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idPlg = preferences.getString("idPlg");
    });
    // _fetchData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    convertModel();
    print(widget.rekeningModel.nama_bank);
  }

  convertModel() {
    nominalTagihan = uangFormat(widget.detailDepositModel.jml_deposit);
    kodeUnik = uangFormat(widget.detailDepositModel.kode_unik);
    total = int.parse(widget.detailDepositModel.jml_deposit) +
        int.parse(widget.detailDepositModel.kode_unik);
    totalTagihan = uangFormat(total.toString());

    var waktuDeposit = DateTime.parse(widget.detailDepositModel.waktu_deposit);
    var formatter = new DateFormat('d MMMM yyyy');
    tglTransaksi = formatter.format(waktuDeposit);
    wktTransaksi = DateFormat('HH:mm:ss').format(waktuDeposit);
    // print(formatted);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaffold,
      floatingActionButton: widget.showButton == true
          ? Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FloatingActionButton(
                    child: Text("LIHAT TAGIHAN"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RiwayatDeposit()),
                          ModalRoute.withName(Navigator.defaultRouteName));
                    },
                  ),
                ],
              ),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("Detail Tagihan"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              tglWaktuTransaksi(),
              rincianTagihan(),
              tujuanRekening(),
              nominalAkhir(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "*Note:\n-Perhatikan nominal transfer harus sama, agar deposit dapat terverifikasi sistem" +
                      "\n-Kode unik akan tetap terhitung pada saldo",
                  style: TextStyle(color: Colors.red[300], fontSize: 12.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget tglWaktuTransaksi() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Tanggal Tagihan",
                  style: styleJudul,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(tglTransaksi)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Waktu Tagihan",
                  style: styleJudul,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text("$wktTransaksi WITA")
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget
  Widget rincianTagihan() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Rincian Tagihan",
              style: styleJudul,
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Nominal Tagihan"),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text("Kode Unik"),
                    ),
                    Text("Total")
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(":"),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(":"),
                    ),
                    Text(":")
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(nominalTagihan),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(kodeUnik),
                    ),
                    Text(totalTagihan)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget tujuanRekening() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Tujuan Rekening",
              style: styleJudul,
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Bank"),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(":"),
                    ),
                    Text(":")
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(widget.rekeningModel.nama_bank),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(widget.rekeningModel.atas_nama_rek),
                    ),
                    InkWell(
                        child: Text(widget.rekeningModel.no_rek),
                        onLongPress: () {
                          Clipboard.setData(
                              new ClipboardData(text: "${widget.rekeningModel.no_rek}"));
                          _keyScaffold.currentState.showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text("No. rekening copied (${widget.rekeningModel.no_rek})"),
                          ));
                        }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget nominalAkhir() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              "Nominal yang harus ditransfer:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5.0,
            ),
            InkWell(
                child: Text(totalTagihan),
                onLongPress: () {
                  Clipboard.setData(new ClipboardData(text: "$total"));
                  _keyScaffold.currentState.showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text("Nominal copied ($total)"),
                  ));
                }),
          ],
        ),
      ),
    );
  }
}
