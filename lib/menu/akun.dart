import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:projek_ta/views/akun/profil.dart';
import 'package:projek_ta/views/akun/tentangKami.dart';
import 'package:projek_ta/views/deposit/penggunaanSaldo.dart';
import 'package:projek_ta/views/deposit/riwayatDeposit.dart';

class Akun extends StatefulWidget {
  final VoidCallback signOut;

  Akun(this.signOut);

  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
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

  _onLoading() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akun"),
        centerTitle: true,
      ),
      body: ListView(children: <Widget>[
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text("Profil Saya"),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => Profil())),
        ),
        ListTile(
          leading: Icon(Icons.account_balance_wallet),
          title: Text("Riwayat Deposit Saldo"),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => RiwayatDeposit())),
        ),
        ListTile(
          leading: Icon(Icons.show_chart),
          title: Text("Mutasi Penggunaan Saldo"),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => PenggunaanSaldo())),
        ),
        ListTile(
          leading: Icon(Icons.verified_user),
          title: Text("Tentang Kami"),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => TentangKami())),
        ),
        ListTile(
          leading: Icon(Icons.lock_open),
          title: Text("Keluar"),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            _alertDialogShow();
          },
        ),
      ]),
    );
  }
}
