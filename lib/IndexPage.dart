import 'package:flutter/material.dart';
import 'package:projek_ta/menu/Pesanan.dart';
// import 'package:projek_ta/menu/akun.dart';
import 'package:projek_ta/menu/artikel.dart';
import 'package:projek_ta/ui_pisah/carousel.dart';
import 'package:projek_ta/menu/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexPage extends StatefulWidget {
  final VoidCallback signOut;

  IndexPage(this.signOut);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  String emailPlg, namaPlg, idPlg, saldoPlg;
  int _selectPage = 0;
  var _pageOption = [];

  int status;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      status = preferences.getInt("status");
      emailPlg = preferences.getString("emailPlg");
      namaPlg = preferences.getString("namaPlg");
      saldoPlg = preferences.getString("saldoPlg");
      idPlg = preferences.getString("idPlg");
      // _loginStatus = value == "1" ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _pageOption = [
      Home(widget.signOut),
      Pesanan(),
      Artikel(),
      CarouselDemo(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOption[_selectPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectPage,
        onTap: (int i) {
          setState(() {
            _selectPage = i;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('Beranda')),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket), title: Text('Pesanan')),
          BottomNavigationBarItem(
              icon: Icon(Icons.subtitles), title: Text('Artikel')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text('Akun'))
        ],
      ),
    );
  }
}
