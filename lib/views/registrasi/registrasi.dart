import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:projek_ta/model/api.dart';

class Registrasi extends StatefulWidget {
  @override
  _RegistrasiState createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  String emailPlg, passPlg, nmPanggilPlg, nmLengkapPlg;

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
      // _onLoading();

      print("$nmLengkapPlg $nmPanggilPlg $passPlg $emailPlg");

      form.save();
      loadingDialog();

      // registrasi();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  void apakahYakin() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Tidak"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  check();
                },
                child: Text("Ya"),
              )
            ],
            title: Text("Apakah anda yakin?"),
          );
        });
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

    registrasi();
  }

  var loading = false;

  registrasi() async {
    setState(() {
      loading = true;
    });

    final response = await http.post(BaseUrl.registrasi, body: {
      "nama_plg": "$nmLengkapPlg",
      "nama_pgl_plg": "$nmPanggilPlg",
      "email_plg": "$emailPlg",
      "pass_plg": "$passPlg"
    });

    final dataBody = jsonDecode(response.body);
    if (dataBody['status'] == 1) {
      //jika sukses mendaftar
      setState(() {
        loading = false;
        Navigator.pop(context);
        showSimpleNotification(context,Text(dataBody['message']),
            background: Colors.green);
        Navigator.pop(context);
      });
    } else {
      setState(() {
        loading = false;
        Navigator.pop(context);
        showSimpleNotification(context,Text(dataBody['message']),
            background: Colors.red);
      });
    }
  }

  InputDecoration styleTextField(String hintText, IconData icon) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 80, 116, 183))),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        prefixIcon: Icon(icon, color: Colors.white),
        hintStyle: TextStyle(
            color: Color.fromARGB(100, 255, 255, 255), fontSize: 14.0),
        hintText: hintText);
  }

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(
                      height: 25.0,
                    ),
                    Text("DAFTAR\nAKUN BARU",
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      onSaved: (e) {
                        nmLengkapPlg = e;
                      },
                      keyboardType: TextInputType.text,
                      autovalidate: _autovalidate,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Masukan nama anda";
                        } else {
                          return null;
                        }
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: styleTextField(
                          "Masukan nama lengkap anda", Icons.person),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      onSaved: (e) {
                        nmPanggilPlg = e;
                      },
                      keyboardType: TextInputType.text,
                      autovalidate: _autovalidate,
                      validator: (e) {
                        List<String> temp = [];
                        temp = e.split(" ");
                        if (temp.length != 1) {
                          return "Isi 1 kata panggilan anda";
                        } else {
                          return null;
                        }
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: styleTextField(
                          "Masukan 1 kata panggilan anda",
                          Icons.person_outline),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.0,
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
                      decoration:
                          styleTextField("Masukan Email Anda", Icons.email),
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
                                  color: Color.fromARGB(255, 80, 116, 183))),
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
                              apakahYakin();
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
