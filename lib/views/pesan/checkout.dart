import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:projek_ta/custom/formatUang.dart';
import 'package:projek_ta/main.dart';
import 'package:projek_ta/menu/pesanan.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/model/detailJasaModel.dart';
import 'package:projek_ta/model/ongkirModel.dart';
import 'package:http/http.dart' as http;
import 'package:projek_ta/views/deposit/deposit_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  final Map
      dataPesanan; // {1: 1, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0, 16: 1, waktu_jemput: 2019-06-27 17:00:00, alamat_pesanan: asd, id_ongkir: 1, nohp_pemesan: 123, catatan_pesanan: asd, id_metode_bayar: null, id_plg: 29}
  final List<OngkirModel> dataOngkir;
  final List<DetailJasaModel> dtDbDetailJasa; //data detail jasa sesuai database

  String idPlg, saldoPlg;

  Checkout(this.dataPesanan, this.dataOngkir, this.dtDbDetailJasa);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  FormatUang frUang = new FormatUang();
  final Color warnaPrimary = Color.fromARGB(255, 116, 150, 213);
  final TextStyle styleJudul = TextStyle(
      color: Color.fromARGB(255, 116, 150, 213), fontWeight: FontWeight.bold);

  String tglJemput, wktJemput, alamat_pesanan;
  Map dataDetailJasa; //data index semua jasa cth: {1: 1, 2: 0, 3: 1, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0, 16: 0}
  Map dataPilihanDetailJasa; // data jasa yang dipilih : {1:1, 3:1} = key = nama jasa, value = jumlah dipilihnya
  int id_ongkir;
  int totalTarif = 0;
  int diskon = 0;
  int grandTotal;

  String metodBayar = "";
  _pilihMetodBayar(String value) {
    setState(() {
      metodBayar = value;
      widget.dataPesanan["id_metode_bayar"] = value;
    });
    if (metodBayar == "1") {
      if (totalTarif > int.parse(widget.saldoPlg)) {
        _snackBarShow(
            "Maaf saldo anda tidak mencukupi, silahkan isi saldo terlebih dahulu",
            true,
            _alertDialogShowSaldoKurang);
      }
    }
  }

  final _scaffoldState = new GlobalKey<ScaffoldState>();

  _snackBarShow(String value, bool onPres, VoidCallback function) {
    _scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(value),
      backgroundColor: Colors.red,
      // duration: Duration(seconds: 1),
      action: SnackBarAction(
        textColor: Colors.white,
        label: "OK",
        onPressed: () {
          if (onPres) {
            function();
          }
        },
      ),
    ));
  }

  getData() async {
    var queryParameters = {'id_plg': widget.idPlg};
    var uri = Uri.parse(BaseUrl.akun)
        .replace(queryParameters: queryParameters)
        .toString();
    final response = await http.get(uri);
    final data = jsonDecode(response.body);
    final dataAkun = data['data_akun'];

    if (response.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        preferences.setString("saldoPlg", dataAkun['saldo_plg']);
        print("SharedPref saldoPlg diganti");
      });
    } else {
      print("SharedPref saldoPlg gagal diganti");
    }
  }

  postData() async {
    Map original = Map.from(widget.dataPesanan);
    original.forEach((key, value) {
      original[key] = value.toString();
    });

    final response = await http.post(BaseUrl.pesanan, body: original);

    final data = jsonDecode(response.body);
    final status = data['status'];
    final pesan = data['message'];
    if (status == 1) {
      print(pesan);
      // Navigator.pop(context);
      _onLoadingBerhasil();
    } else {
      print(pesan);
      Navigator.pop(context);
      _onLoadingGagal();
    }
  }

  void _onLoadingBerhasil() {
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
      showSimpleNotification(context,
          Text("Pesanan berhasil dibuat, admin akan segera menghubungi anda"),
          background: Colors.green);

      getData();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Pesanan()),
          ModalRoute.withName(Navigator.defaultRouteName));
    });
  }

  void _onLoadingGagal() {
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
      showSimpleNotification(context, Text("Gagal"), background: Colors.red);
      Navigator.pop(context);
    });
  }

  _alertDialogShow(String metodBayar, String ket) {
    final sizeScreen = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Apakah anda yakin?"),
            content: Container(
              height: sizeScreen.height / 6,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Metode pembayaran:"),
                    Text(
                      "$metodBayar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("$ket"),
                    Text("${frUang.uangFormat(totalTarif.toString())}",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ]),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Batal"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("Konfirmasi"),
                onPressed: () {
                  postData();
                },
              ),
            ],
          );
        });
  }

  _alertDialogShowSaldoKurang() {
    final sizeScreen = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Saldo anda tidak mencukupi"),
            content: Container(
              height: sizeScreen.height / 10,
              child: Center(child: Text("Apakah anda ingin deposit saldo?")),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Tidak"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("Deposit"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DepositView()));
                },
              ),
            ],
          );
        });
  }

  _aksiFloatingButton() {
    if (metodBayar.isNotEmpty) {
      if (metodBayar == "1") {
        if (totalTarif > int.parse(widget.saldoPlg)) {
          _alertDialogShowSaldoKurang();
        } else {
          _alertDialogShow("Potong Saldo", "Saldo anda akan terpotong");
        }
      } else {
        _alertDialogShow(
            "Cash On Delivery (COD)", "Tagihan yang harus dibayarkan");
      }
      // postData();
      // Navigator.popUntil(context, ModalRoute.withName('/home'));
    } else {
      _snackBarShow("Pilih Metode Pembayaran", false, null);
      print("Pilih metode");
    }
  }

  isiNilaiProperti() {
    //tentang waktu dan tanggal jemput
    var wktJemputWidget = DateTime.parse(widget.dataPesanan['waktu_jemput']);
    wktJemput = DateFormat('HH:mm:ss').format(wktJemputWidget);
    var formatter = new DateFormat('d MMMM yyyy');
    tglJemput = formatter.format(wktJemputWidget);

    //tentang alamat jemput
    alamat_pesanan = widget.dataPesanan['alamat_pesanan'];

    //tentang data jasa dan data pesanan meambil 16 data jasa
    int jmlJasa = widget.dtDbDetailJasa.length;
    dataDetailJasa = Map.fromIterables(
        widget.dataPesanan.keys.skip(0).take(jmlJasa),
        widget.dataPesanan.values.skip(0).take(jmlJasa));

    dataPilihanDetailJasa = Map.from(dataDetailJasa);
    dataPilihanDetailJasa.removeWhere(
        (key, value) => value == 0); //menghapus element yg nilainya 0

    //tentang id ongkir
    id_ongkir = widget.dataPesanan["id_ongkir"];
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      widget.idPlg = preferences.getString("idPlg");
      widget.saldoPlg = preferences.getString("saldoPlg");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isiNilaiProperti();
    getPref();

    print(dataPilihanDetailJasa);
    print(dataDetailJasa);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldState,
        persistentFooterButtons: <Widget>[
          MaterialButton(
            onPressed: () => _aksiFloatingButton(),
            // minWidth: screenSize.width / 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Color.fromARGB(255, 116, 150, 213),
            child: Row(
              children: <Widget>[
                Text("Buat Pesanan"),
                Icon(Icons.chevron_right)
              ],
            ),
            textColor: Colors.white,
          )
        ],
        appBar: AppBar(
          title: Text("Checkout"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                tglWktJemput(), //tanggal dan waktu jemput
                SizedBox(
                  height: 10.0,
                ),
                alamatJemput(), //alamat jemput
                Divider(),
                detailPesanan(),
                Divider(),
                kodePromo(),
                Divider(),
                rekap(),
                Divider(),
                metodeBayar()
              ],
            ),
          ),
        ));
  }

  Widget tglWktJemput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Tanggal Jemput',
              style: styleJudul,
            ),
            SizedBox(
              height: 3.0,
            ),
            Text(tglJemput)
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Waktu Jemput', style: styleJudul),
            SizedBox(
              height: 3.0,
            ),
            Text("$wktJemput WITA")
          ],
        )
      ],
    );
  }

  Widget alamatJemput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Alamat Jemput',
          style: styleJudul,
        ),
        SizedBox(
          height: 3.0,
        ),
        Text(
          alamat_pesanan,
          textAlign: TextAlign.left,
        )
      ],
    );
  }

  Widget dataDetailPesanan() {
    var size = MediaQuery.of(context).size;

    List<Widget> rowDtlPesanan = [];
    var dtDbDj = List.from(widget.dtDbDetailJasa);

    rowDtlPesanan.clear();
    // totalTarif = 0;

    dataPilihanDetailJasa.forEach((key, value) {
      var index = int.parse(key) - 1;

      var tarif = int.parse(dtDbDj[index].tarif); //tarif jasanya
      totalTarif += (tarif * value);

      final double itemHeight = (size.height / 24);
      final double itemWidth = (size.width / 2);

      rowDtlPesanan.add(GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: 3,
        children: <Widget>[
          Text("${dtDbDj[index].nama_detail_jasa}"),
          Text(
            '$value Pasang',
            textAlign: TextAlign.end,
          ),
          Text(
            "${frUang.uangFormat(tarif.toString())}",
            textAlign: TextAlign.end,
          )
        ],
      ));
    });

    return Column(
      children: rowDtlPesanan,
    );
  }

  Widget detailPesanan() {
    totalTarif = 0;
    String tarifOngkir =
        widget.dataOngkir[id_ongkir - 1].tarif_ongkir; //tarif ongkir
    totalTarif += int.parse(tarifOngkir);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Detail Pesanan',
          style: styleJudul,
        ),
        SizedBox(
          height: 3.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            dataDetailPesanan(),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Transportasi'),
                Text(frUang.uangFormat(tarifOngkir))
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget kodePromo() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.scatter_plot,
          color: warnaPrimary,
        ),
        InkWell(onTap: () {}, child: Text('Kode Promo'))
      ],
    );
  }

  Widget rekap() {
    // grandTotal = 0;
    //tentang grand total
    grandTotal = totalTarif - diskon;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Total'),
            Text("${frUang.uangFormat(totalTarif.toString())}")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text('Diskon'), Text('$diskon')],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Grand Total'),
            Text("${frUang.uangFormat(grandTotal.toString())}")
          ],
        ),
      ],
    );
  }

  Widget metodeBayar() {
    var size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Metode Pembayaran', style: styleJudul),
        SizedBox(
          height: 10.0,
        ),
        Container(
          color: Colors.grey[300],
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Radio(
                      groupValue: metodBayar,
                      onChanged: (value) {
                        _pilihMetodBayar(value);
                      },
                      value: "1",
                      activeColor: warnaPrimary,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Saldo",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                        Text("Bayar tagihan dengan saldo anda",
                            style: TextStyle(
                              fontSize: 10.0,
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      // width: size.width / 3,
                      padding: EdgeInsets.all(8.0),
                      color: warnaPrimary,
                      child: Text(
                        "Saldo anda : ${frUang.uangFormat(widget.saldoPlg)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8.0, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Radio(
                      groupValue: metodBayar,
                      onChanged: (value) {
                        _pilihMetodBayar(value);
                      },
                      value: "2",
                      activeColor: warnaPrimary,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Cash On Delivery (COD)",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                        Text("Bayar tagihan langsung ditempat",
                            style: TextStyle(
                              fontSize: 10.0,
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(""),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
