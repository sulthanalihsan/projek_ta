import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projek_ta/custom/formatUang.dart';
import 'package:projek_ta/views/akun/editProfil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String idPlg,
      saldoPlg,
      namaPlg,
      namaPglPlg,
      emailPlg,
      jkPlg,
      noHpPlg,
      alamatPlg;
  int jmlRwtPesanan;

  var loading = false;
  getPref() async {
    setState(() {
      loading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      saldoPlg = FormatUang().uangFormat(preferences.getString("saldoPlg"));
      namaPlg = preferences.getString("namaPlg");
      idPlg = preferences.getString("idPlg");
      namaPglPlg = preferences.getString("namaPglPlg");
      emailPlg = preferences.getString("emailPlg");
      jkPlg = preferences.getString("jkPlg");
      noHpPlg = preferences.getString("noHpPlg");
      alamatPlg = preferences.getString("alamatPlg");
      jmlRwtPesanan = preferences.getInt("jmlRwtPesanan");
      loading = false;
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Profil saya"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Card(
                        elevation: 5.0,
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfil(
                                      idPlg,
                                      namaPlg,
                                      namaPglPlg,
                                      emailPlg,
                                      jkPlg,
                                      noHpPlg,
                                      alamatPlg))),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: CircleAvatar(
                                            // radius: 50.0,
                                            minRadius: 50.0,
                                            backgroundColor: Colors.white,
                                            child: Image.asset(
                                              './img/logods.png',
                                              width: 140.0,
                                            ),
                                          )),
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "$namaPlg",
                                                textScaleFactor: 1.4,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text("$emailPlg"),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text("Saldo sekarang"),
                                        Text("$saldoPlg")
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text("Riwayat Pesananan"),
                                        Text("${jmlRwtPesanan}x pesanan")
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text("Point"),
                                        Text("100")
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: InkWell(
                          child: Icon(Icons.edit,
                              size: 20.0,
                              color: Theme.of(context).primaryColor),
                          onTap: () {},
                        ),
                      )
                    ],
                  ),
                  Card(
                    elevation: 5.0,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              dataProfil("Nama", namaPlg),
                              dataProfil("Panggilan", namaPglPlg),
                              dataProfil("Email", emailPlg),
                              dataProfil(
                                  "Jenis Kelamin",
                                  jkPlg == "L"
                                      ? "Laki-laki"
                                      : (jkPlg == "P" ? "Perumpuan" : "-")),
                              dataProfil(
                                  "Nomor Hp", noHpPlg == null ? "-" : noHpPlg),
                              dataProfil("Alamat",
                                  alamatPlg == null ? "-" : alamatPlg),
                            ])),
                  ),
                ],
              ),
            ),
    );
  }

  Widget dataProfil(String label, String datanya) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "$label :",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text("$datanya"),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
        )
      ],
    );
  }
}
