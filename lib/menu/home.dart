import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/ui_pisah/carousel.dart';
import 'package:projek_ta/views/deposit/deposit_view.dart';
import 'package:projek_ta/views/deposit/testing.dart';
import 'package:projek_ta/views/pesan/pesan.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_ta/custom/formatUang.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final VoidCallback signOut;
  String saldoPlg, idPlg, namaPglPlg;

  Home(this.signOut);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FormatUang frUang = new FormatUang();
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  _snackbarShow(String str) {
    _scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(str),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
      ),
    ));
  }

  _alertDialogShow() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Keluar dari aplikasi?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Batal"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                  child: new Text("Keluar"),
                  onPressed: () {
                    Navigator.pop(context);
                    _onLoading();
                  }),
            ],
          );
        });
  }

  void _onLoading() {
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

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      widget.signOut();
      showSimpleNotification(context,Text("Berhasil keluar"),
          background: Colors.red);
    });
  }

  var loading = false;
  Future<void> _getData() async {
    setState(() {
      loading = true;
    });

    var queryParameters = {'id_plg': widget.idPlg};
    var uri = Uri.parse(BaseUrl.akun)
        .replace(queryParameters: queryParameters)
        .toString();
    final response = await http.get(uri);
    final data = jsonDecode(response.body);
    final dataAkun = data['data_akun'];

    if (response.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (dataAkun['saldo_plg'] != widget.saldoPlg) {
        setState(() {
          //mengganti data pref saldoPlg bila tidak sama dengan di api
          preferences.setString("saldoPlg", dataAkun['saldo_plg']);
          preferences.setInt("jmlRwtPesanan", dataAkun['transaksi']);
          widget.saldoPlg = preferences.getString("saldoPlg");
          print("SharedPref saldoPlg diganti");
        });
      } else {
        print("data shared saldo sama dengan api");
      }
    } else {
      print("SharedPref saldoPlg gagal diganti, koneksi putus");
    }

    getPref();
  }

  // String saldoPlg,idPlg;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      widget.saldoPlg = preferences.getString("saldoPlg");
      widget.idPlg = preferences.getString("idPlg");
      widget.namaPglPlg = preferences.getString("namaPglPlg");
      // widget.saldoPlg = frUang.formatUnSimbol(widget.saldoPlg);
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    print(widget.saldoPlg);
  }

  final _refresh = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _refresh.currentState.show();
          },
          icon: Icon(Icons.home),
        ),
        title: Text("Beranda"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color.fromARGB(255, 116, 150, 213),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _alertDialogShow();
            },
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _getData,
        key: _refresh,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Stack(children: <Widget>[
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 140.0,
                        // height: screenSize.height / 3.5,
                        color: Color.fromARGB(255, 116, 150, 213),
                      ),
                      SizedBox(
                        height: 80.0,
                      ),
                      CarouselDemo(),
                      SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: FloatingActionButton(
                          backgroundColor: Color.fromARGB(255, 116, 150, 213),
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Pesan())),
                          child: Icon(
                            Icons.add_shopping_cart,
                            size: 30.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 35.0,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'WELCOME ${widget.namaPglPlg.toUpperCase()}',
                            style:
                                TextStyle(fontSize: 32.0, color: Colors.white),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DepositView())),
                                // builder: (context) => Testing())),
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    // height: screenSize.width / 3.35,
                                    // width: screenSize.width / 2.3,
                                    height: 110.0,
                                    width: 160.0,
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Saldo",
                                                style:
                                                    TextStyle(fontSize: 16.0)),
                                            Icon(
                                              Icons.account_balance_wallet,
                                              color: Colors.green,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.fill,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                frUang.formatUnSimbol(
                                                    widget.saldoPlg),
                                                textScaleFactor: 1.2,
                                                style: TextStyle(
                                                    fontSize: 22.0,
                                                    color: Color.fromARGB(
                                                        255, 116, 150, 213)),
                                              ),
                                              Text(
                                                'idr',
                                                textScaleFactor: 1.2,
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Color.fromARGB(
                                                        255, 116, 150, 213)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    _snackbarShow('Fitur ini belum tersedia'),
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    height: 110.0,
                                    width: 160.0,
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Point",
                                                style:
                                                    TextStyle(fontSize: 16.0)),
                                            Icon(
                                              Icons.adjust,
                                              color: Colors.yellow,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '100',
                                              textScaleFactor: 1.2,
                                              style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: Color.fromARGB(
                                                      255, 116, 150, 213)),
                                            ),
                                            Text(
                                              'pt',
                                              textScaleFactor: 1.2,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Color.fromARGB(
                                                      255, 116, 150, 213)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ]),
              ),
      ),
    );
  }
}
