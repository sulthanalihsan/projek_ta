import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projek_ta/IndexPage.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/views/deposit/deposit_view.dart';
import 'package:projek_ta/views/registrasi/registrasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  _MyAppState _myAppState = new _MyAppState();

  runApp(MaterialApp(
      home: MyApp(),
      routes: {
        "/home": (context) => MyApp(),
        "/home/deposit_view": (context) => DepositView(),
        "/tab2": (context) => IndexPage(_myAppState.signOut, 1),
      },
      // initialRoute: MyApp.routeName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color.fromARGB(255, 116, 150, 213),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color.fromARGB(255, 116, 150, 213)))));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum LoginStatus { notSignIn, signIn }

class _MyAppState extends State<MyApp> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String emailPlg, passPlg;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autovalidate = false;
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      _onLoading();
      form.save();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,
        body: {"email_plg": emailPlg, "pass_plg": passPlg});
    final dataBody = jsonDecode(response.body);
    print(dataBody['status']);
    int status = dataBody['status'];
    String pesan = dataBody['message'];
    final data = dataBody['data_akun'];

    if (status == 1) {
      showSimpleNotification(context,Text("Login Berhasil"),
          background: Colors.green);
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(
            status,
            data['id_plg'],
            data['email_plg'],
            data['nama_plg'],
            data['nama_pgl_plg'],
            data['saldo_plg'],
            data['jk_plg'],
            data['nohp_plg'],
            data['alamat_plg'],
            data['transaksi']);
      });
      // print("JUMLAH TRANSAKSI");
      // print(data['transaksi']);
      // print(data);
    } else {
      showSimpleNotification(context,
         Text("Login Gagal, Email atau password salah"),
          background: Colors.red);
      setState(() {
        _loginStatus = LoginStatus.notSignIn;
      });
      print(pesan);
    }
  }

  savePref(
      int status,
      String idPlg,
      String emailPlg,
      String namaPlg,
      String namaPglPlg,
      String saldoPlg,
      String jkPlg,
      String noHpPlg,
      String alamatPlg,
      int jmlRwtPesanan) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("status", status);
      preferences.setString("idPlg", idPlg);
      preferences.setString("emailPlg", emailPlg);
      preferences.setString("namaPlg", namaPlg);
      preferences.setString("namaPglPlg", namaPglPlg);
      preferences.setString("saldoPlg", saldoPlg);
      preferences.setString("jkPlg", jkPlg);
      preferences.setString("noHpPlg", noHpPlg);
      preferences.setString("alamatPlg", alamatPlg);
      preferences.setInt("jmlRwtPesanan", jmlRwtPesanan);
      preferences.commit();
    });
  }

  int status;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      status = preferences.getInt("status");
      _loginStatus = status == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("status", null);
      preferences.setString("idPlg", null);
      preferences.setString("emailPlg", null);
      preferences.setString("saldoPlg", null);
      _loginStatus = LoginStatus.notSignIn;
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
      login();
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 116, 150, 213),
          body: Container(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          './img/logods.png',
                          width: 140.0,
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        TextFormField(
                          onSaved: (e) => emailPlg = e,
                          keyboardType: TextInputType.emailAddress,
                          autovalidate: _autovalidate,
                          validator: (e) {
                            if (!e.contains("@")) {
                              return "Masukan format email yang benar";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 80, 116, 183))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.white),
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(100, 255, 255, 255),
                                  fontSize: 14.0),
                              hintText: "Masukan Email Anda"),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          obscureText: _secureText,
                          onSaved: (e) => passPlg = e,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.white),
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                color: Color.fromARGB(255, 80, 116, 183),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 80, 116, 183))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(100, 255, 255, 255),
                                  fontSize: 14.0),
                              hintText: "Masukan Password Anda"),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: MaterialButton(
                                color: Color.fromARGB(255, 80, 116, 183),
                                onPressed: () {
                                  check();
                                },
                                child: Text(
                                  "Masuk",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Registrasi())),
                            child: Text(
                              'Belum punya akun? Klik Disini',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 80, 116, 183)),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        break;

      case LoginStatus.signIn:
        return IndexPage(signOut, 0);
    }
  }
}
