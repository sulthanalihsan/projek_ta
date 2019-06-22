import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projek_ta/menu/pesanan.dart';
import 'package:projek_ta/ui_pisah/carousel.dart';
import 'package:projek_ta/views/deposit/deposit_view.dart';
import 'package:projek_ta/views/pesan/pesan.dart';

class Home extends StatefulWidget {
  final VoidCallback signOut;

  Home(this.signOut);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        leading: Icon(Icons.person_outline),
        title: Text("Beranda"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color.fromARGB(255, 116, 150, 213),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              widget.signOut();
            },
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: 140.0,
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
                onPressed: () => Navigator.pushNamed(context, '/home/deposit_view'),
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
                  'WELCOME SULTHAN',
                  style: TextStyle(fontSize: 32.0, color: Colors.white),
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
                                  Text("Saldo",
                                      style: TextStyle(fontSize: 16.0)),
                                  Icon(
                                    Icons.account_balance_wallet,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '500.000',
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color:
                                            Color.fromARGB(255, 116, 150, 213)),
                                  ),
                                  Text(
                                    'idr',
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color:
                                            Color.fromARGB(255, 116, 150, 213)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _snackbarShow('Fitur ini belum tersedia'),
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
                                      style: TextStyle(fontSize: 16.0)),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '100',
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color:
                                            Color.fromARGB(255, 116, 150, 213)),
                                  ),
                                  Text(
                                    'pt',
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color:
                                            Color.fromARGB(255, 116, 150, 213)),
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
    );
  }
}
