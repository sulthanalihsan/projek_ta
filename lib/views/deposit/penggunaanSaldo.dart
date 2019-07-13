import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:projek_ta/custom/formatUang.dart';
import 'package:projek_ta/menu/home.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/model/depositModel.dart';
import 'package:projek_ta/model/detailJasaModel.dart';
import 'package:projek_ta/model/jasaModel.dart';
import 'package:projek_ta/model/metodeBayarModel.dart';
import 'package:projek_ta/model/ongkirModel.dart';
import 'package:projek_ta/model/rekeningModel.dart';
import 'package:projek_ta/model/riwayatSaldoModel.dart';
import 'package:projek_ta/model/statusModel.dart';
import 'package:projek_ta/views/deposit/detailTagihan.dart';
import 'package:projek_ta/views/pesan/detailPesanan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PenggunaanSaldo extends StatefulWidget {
  @override
  _PenggunaanSaldoState createState() => _PenggunaanSaldoState();
}

class _PenggunaanSaldoState extends State<PenggunaanSaldo> {
  var loading = false;

  FormatUang fr = new FormatUang();
  String idPlg, saldoPlg;

  Future<void> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idPlg = preferences.getString("idPlg");
      saldoPlg = preferences.getString("saldoPlg");
    });
    getDataRiwayatSaldo();
  }

  final listRiwayatSaldo = new List<RiwayatSaldoModel>();

  Future<Null> getDataRiwayatSaldo() async {
    listRiwayatSaldo.clear();

    setState(() {
      loading = true;
    });

    var queryParameters = {'id_plg': idPlg};
    var uri = Uri.parse(BaseUrl.riwayatSaldo)
        .replace(queryParameters: queryParameters)
        .toString();
    final response = await http.get(uri);
    final data = jsonDecode(response.body);
    final dataRiwayatSaldo = data['data_riwayat_saldo'];

    if (response.statusCode == 200) {
      dataRiwayatSaldo.forEach((api) {
        final temp = new RiwayatSaldoModel(
            api['id_riwayat_saldo'],
            api['id_transaksi'],
            api['id_plg'],
            api['tgl_riwayat'],
            api['type'],
            api['nominal'],
            api['saldo_awal']);

        listRiwayatSaldo.add(temp);
      });
      print(data['message']);
    } else {
      print(data['message']);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  final GlobalKey<RefreshIndicatorState> _refresh =
      new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    FormatUang fr = new FormatUang();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Mutasi Saldo"),
          centerTitle: true,
        ),
        body: loading
            ? RefreshIndicator(
                onRefresh: getPref,
                key: _refresh,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ))
            : Column(
                children: <Widget>[
                  Container(
                    height:
                        screenSize.height / 6 + AppBar().preferredSize.height,
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  'Saldo anda saat ini',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                                Text(
                                  "${fr.uangFormat(saldoPlg)}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30.0, color: Colors.white),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Saldo tersedia',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    ),
                                    Text(
                                      '${fr.uangFormat(saldoPlg)}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.white),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Transaksi terakhir',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    ),
                                    Text(
                                      '${listRiwayatSaldo.last.type == "kredit" ? "-" : (listRiwayatSaldo.last.type != "saldo awal" ? "+" : "")}${fr.formatUnSimbol(listRiwayatSaldo.last.nominal)}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.white),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Material(
                    elevation: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 24.0, left: 24.0, top: 16.0, bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Data mutasi saldo"),
                          Icon(
                            Icons.account_balance_wallet,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                        key: _refresh,
                        onRefresh: getDataRiwayatSaldo,
                        child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: wgRiwayatSaldo())),
                  )
                ],
              ));
  }

  Widget wgRiwayatSaldo() {
    final screenSize = MediaQuery.of(context).size;
    List<Widget> list = [];

    for (RiwayatSaldoModel item in listRiwayatSaldo) {
      var plusMin =
          item.type == "kredit" ? "-" : (item.type != "saldo awal" ? "+" : " ");

      var subTitleRiwayat;
      if (item.type == "debit") {
        subTitleRiwayat = int.parse(item.saldo_awal) + int.parse(item.nominal);
      } else {
        subTitleRiwayat = int.parse(item.saldo_awal) - int.parse(item.nominal);
      }

      list.add(Container(
        padding:
            EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
        margin: EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      item.type == "kredit"
                          ? Icons.shopping_basket
                          : (item.type != "saldo awal"
                              ? Icons.account_balance_wallet
                              : Icons.adjust),
                      color: Colors.grey,
                    ),
                    Padding(padding: EdgeInsets.only(left: 16.0)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        item.type == "kredit"
                            ? Text("Pesanan")
                            : (item.type != "saldo awal"
                                ? Text("Deposit Saldo")
                                : Text("Saldo Awal")),
                        Text(
                          item.tgl_riwayat,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                  ],
                ),
                Material(
                  borderRadius: BorderRadius.circular(15.0),
                  color: item.type == "kredit"
                      ? Colors.red[300]
                      : (item.type != "saldo awal"
                          ? Colors.blue[300]
                          : Colors.grey[300]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0.7, bottom: 0.7, left: 3.0, right: 3.0),
                    child: Text(item.type,
                        style: TextStyle(fontSize: 12.0, color: Colors.white)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "$plusMin${fr.formatUnSimbol(item.nominal)}",
                          style: TextStyle(
                              color: item.type == "kredit"
                                  ? Colors.red[300]
                                  : (item.type != "saldo awal"
                                      ? Colors.blue[300]
                                      : Colors.black)),
                        ),
                        Text(
                          "${fr.uangFormat(subTitleRiwayat.toString())}",
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Icon(
                      item.type == "kredit"
                          ? Icons.arrow_downward
                          : (item.type != "saldo awal"
                              ? Icons.arrow_upward
                              : null),
                      color: item.type == "kredit"
                          ? Colors.red[300]
                          : (item.type != "saldo awal"
                              ? Colors.blue[300]
                              : Colors.grey[300]),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ));
    }

    // membalik dan meambil 20 data saja
    list = list.reversed.toList();
    list = list.take(20).toList();

    return Column(
      children: list,
    );
  }
}
