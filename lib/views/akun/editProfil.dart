import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/ui_pisah/loadingDialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfil extends StatefulWidget {
  final String idPlg, namaPlg, namaPglPlg, emailPlg, jkPlg, noHpPlg, alamatPlg;

  const EditProfil(this.idPlg, this.namaPlg, this.namaPglPlg, this.emailPlg,
      this.jkPlg, this.noHpPlg, this.alamatPlg);
  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  String namaPlg, namaPglPlg, emailPlg, jkPlg, noHpPlg, alamatPlg;

  TextEditingController namaPlgCont,
      namaPglPlgCont,
      emailPlgCont,
      jkPlgCont,
      noHpPlgCont,
      alamatPlgCont;

  setup() {
    namaPlgCont = TextEditingController(text: widget.namaPlg);
    namaPglPlgCont = TextEditingController(text: widget.namaPglPlg);
    emailPlgCont = TextEditingController(text: widget.emailPlg);
    jkPlgCont = TextEditingController(text: widget.jkPlg);
    noHpPlgCont = TextEditingController(text: widget.noHpPlg);
    alamatPlgCont = TextEditingController(text: widget.alamatPlg);
  }

  var _validate = false;
  final _formState = GlobalKey<FormState>();
  final _scaffoldState = GlobalKey<ScaffoldState>();
  void check() {
    final form = _formState.currentState;
    if (form.validate()) {
      form.save();
      LoadingDialog().loadingDialog(context, postData);
      print("checking....");
      print("$namaPlg $namaPglPlg $emailPlg $jkPlg $noHpPlg $alamatPlg");
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  postData() async {
    final response = await http.post(BaseUrl.editProfil, body: {
      'id_plg': "${widget.idPlg}",
      'nama_plg': "$namaPlg",
      'nama_pgl_plg': "$namaPglPlg",
      'email_plg': "$emailPlg",
      'jk_plg': "$jkPlg",
      'nohp_plg': "$noHpPlg",
      'alamat_plg': "$alamatPlg"
    });

    final dataBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(dataBody['message']);
      savePref();
    }
  }

  savePref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
    preferences.setString(namaPglPlg, namaPglPlg);
    preferences.commit();
    });
          Navigator.pop(context);

      
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text("Edit Profil"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: namaPlgCont,
                  autovalidate: _validate,
                  onSaved: (e) => namaPlg = e,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Field ini tidak boleh kosong";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Nama Lengkap Anda",
                    hintText: "Masukkan alamat anda",
                  ),
                ),
                TextFormField(
                  controller: namaPglPlgCont,
                  autovalidate: _validate,
                  onSaved: (e) => namaPglPlg = e,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Field ini tidak boleh kosong";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Nama Panggilan Anda",
                    hintText: "Masukkan Nama Panggilan Anda",
                  ),
                ),
                TextFormField(
                  controller: emailPlgCont,
                  autovalidate: _validate,
                  onSaved: (e) => emailPlg = e,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Field ini tidak boleh kosong";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Email Anda",
                    hintText: "Masukkan Email anda",
                  ),
                ),
                TextFormField(
                  controller: jkPlgCont,
                  autovalidate: _validate,
                  onSaved: (e) => jkPlg = e,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Field ini tidak boleh kosong";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Jenis Kelamin Anda",
                    hintText: "Masukkan jenis kelamin Anda",
                  ),
                ),
                TextFormField(
                  controller: noHpPlgCont,
                  autovalidate: _validate,
                  onSaved: (e) => noHpPlg = e,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Field ini tidak boleh kosong";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "No Handpone Anda",
                    hintText: "Masukkan no handphone anda",
                  ),
                ),
                TextFormField(
                  controller: alamatPlgCont,
                  autovalidate: _validate,
                  onSaved: (e) => alamatPlg = e,
                  maxLines: 2,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Field ini tidak boleh kosong";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Alamat anda",
                    hintText: "Masukkan alamat anda",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: MaterialButton(
                    onPressed: check,
                    child: Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                    height: MediaQuery.of(context).size.height / 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
