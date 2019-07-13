import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projek_ta/custom/formatUang.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/model/detailJasaModel.dart';
import 'package:projek_ta/model/detailPesananModel.dart';
import 'package:projek_ta/model/jasaModel.dart';
import 'package:projek_ta/model/metodeBayarModel.dart';
import 'package:projek_ta/model/ongkirModel.dart';
import 'package:http/http.dart' as http;
import 'package:projek_ta/model/pesananModel.dart';
import 'package:projek_ta/model/statusModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPesanan extends StatefulWidget {
  PesananModel ketPesanan; //data satuan sesuai tabel pesanan
  final List<StatusModel> listDataStatus;
  final List<MetodeBayarModel> listDataMetod;
  final List<OngkirModel> dataOngkir;
  final List<JasaModel> dtDbJasa; //data detail jasa sesuai database
  final List<DetailJasaModel> dtDbDetailJasa; //data detail jasa sesuai database

  String idPlg, saldoPlg;

  DetailPesanan(this.ketPesanan, this.listDataStatus, this.listDataMetod,
      this.dataOngkir, this.dtDbJasa, this.dtDbDetailJasa);

  @override
  _DetailPesananState createState() => _DetailPesananState();
}

class _DetailPesananState extends State<DetailPesanan> {
  FormatUang frUang = new FormatUang();
  final Color warnaPrimary = Color.fromARGB(255, 116, 150, 213);
  final TextStyle styleJudul = TextStyle(
      color: Color.fromARGB(255, 116, 150, 213), fontWeight: FontWeight.bold);

  String ket1IdPesanan,
      ket1StatusPesanan,
      ket1Ongkir,
      ket1MetodBayar,
      ket1AlamatPesanan,
      ket1TglPesan,
      ket1WktPesan,
      ket1NoHp,
      ket2TglJemput,
      ket2WktJemput,
      ket2TglAntar = "-",
      ket2WktAntar = "-";

  //data index semua jasa cth: {1: 1, 2: 0, 3: 1, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0, 16: 0}

  Map<String, dynamic> idJasa_DtlPesanan =
      {}; // data jasa yang dipilih : {1:1, 3:1} = key = nama jasa, value = jumlah dipilihnya
  int id_ongkir;
  int totalTarif = 0;
  int diskon = 0;
  int grandTotal;

  final _scaffoldState = new GlobalKey<ScaffoldState>();
  final listDtDetailPesanan = new List<DetailPesananModel>();

  var loading = false;
  Future<Null> getDataDetailPesanan() async {
    listDtDetailPesanan.clear();
    setState(() {
      loading = true;
    });

    var queryParameters = {'id_pesanan': widget.ketPesanan.id_pesanan};
    var uri = Uri.parse(BaseUrl.detailPesanan)
        .replace(queryParameters: queryParameters)
        .toString();
    final response = await http.get(uri);
    final data = jsonDecode(response.body);
    final dataDetailPesanan = data['data_detail_pesanan'];

    if (response.statusCode == 200) {
      dataDetailPesanan.forEach((api) {
        final temp = new DetailPesananModel(
            api['id_detail_pesanan'],
            api['id_pesanan'],
            api['id_detail_jasa'],
            api['id_status'],
            api['merek_spt'],
            api['size_spt'],
            api['warna_spt'],
            api['foto_sblm'],
            api['foto_ssdh'],
            api['ket_lain']);
        //masukkan data detail pesanan kedalam list
        listDtDetailPesanan.add(temp);

        idJasa_DtlPesanan[api['id_detail_jasa']] =
            0; //meambil id detail jasa yang dipesan
      });
      dataDetailPesanan.forEach((api) {
        idJasa_DtlPesanan[api[
            'id_detail_jasa']]++; //menghitung jumlah detail jasa yang dipesan
      });
      print(data['message']);
    } else {
      print(data['message']);
    }

    isiNilaiProperti();
  }

  detailSepatuPopUp(DetailPesananModel item) {
    var namaStatus =
        widget.listDataStatus[int.parse(item.id_status) - 1].nama_status;

    var fotoSblm =
        item.foto_sblm == "-" ? "default-mobile.png" : item.foto_sblm;
    var fotoSsdh =
        item.foto_ssdh == "-" ? "default-mobile.png" : item.foto_ssdh;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.all(0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 14,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      "DETAIL SEPATU",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    color: Colors.grey[300],
                    width: MediaQuery.of(context).size.width / 1.1,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          elevation: 5.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(8.0),
                                  color: Colors.blueGrey,
                                  child: Center(
                                      child: Text(
                                    "KETERANGAN",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                              Container(
                                height: 120.0,
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Status"),
                                        Text("Merek"),
                                        Text("Warna"),
                                        Text("Size"),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(": "),
                                            Material(
                                              shadowColor: Colors.black,
                                              elevation: 5.0,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: item.id_status == "1"
                                                  ? Colors.orange[400]
                                                  : Colors.green[400],
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text("$namaStatus",
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(": ${item.merek_spt}"),
                                        Text(": ${item.warna_spt}"),
                                        Text(": ${item.size_spt}"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              item.ket_lain == "-"
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          bottom: 16.0),
                                      child: Text("*Catatan:\n${item.ket_lain}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          )),
                                    )
                            ],
                          ),
                        ),
                        Card(
                          elevation: 5.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(8.0),
                                  color: Colors.blueGrey,
                                  child: Center(
                                      child: Text(
                                    "FOTO BEFORE",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  BaseUrl.beforeAfter + fotoSblm,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 5.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(8.0),
                                  color: Colors.blueGrey,
                                  child: Center(
                                      child: Text(
                                    "FOTO AFTER",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  BaseUrl.beforeAfter + fotoSsdh,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                          color: Theme.of(context).primaryColor,
                          splashColor: Colors.grey[400],
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  isiNilaiProperti() {
    //meambil data id pesanan dari widget ke variabel state
    ket1IdPesanan = widget.ketPesanan.id_pesanan;

    //meambil data id pesanan dari widget ke variabel state
    ket1StatusPesanan = widget.ketPesanan.id_status;

    //meambil data id pesanan dari widget ke variabel state
    ket1TglPesan = widget.ketPesanan.id_ongkir;

    // meambil data waktu dan tanggal pesan dari widget ke variabel state
    var tempTglWkt = DateTime.parse(widget.ketPesanan.waktu_pesan);
    ket1TglPesan = DateFormat('d MMMM yyyy').format(tempTglWkt);
    ket1WktPesan = DateFormat('HH:mm:ss').format(tempTglWkt);

    //meambil data metode bayar dari widget ke variabel state
    ket1MetodBayar = widget.ketPesanan.id_metode_bayar;

    //meambil data alamat dari widget ke variabel state
    ket1AlamatPesanan = widget.ketPesanan.alamat_pesanan;

    //meambil data metode bayar dari widget ke variabel state
    ket1NoHp = widget.ketPesanan.nohp_pemesan;

    // meambil data waktu dan tanggal jemput dari widget ke variabel state
    var tempTglWktJemput = DateTime.parse(widget.ketPesanan.waktu_jemput);
    ket2TglJemput = DateFormat('d MMMM yyyy').format(tempTglWktJemput);
    ket2WktJemput = DateFormat('HH:mm:ss').format(tempTglWktJemput);

    // meambil data waktu dan tanggal jemput dari widget ke variabel state
    if (widget.ketPesanan.waktu_antar != null) {
      var tempTglWktAntar = DateTime.parse(widget.ketPesanan.waktu_antar);
      ket2TglAntar = DateFormat('d MMMM yyyy').format(tempTglWktAntar);
      ket2WktAntar = DateFormat('HH:mm:ss').format(tempTglWktAntar);
    }

    //tentang id ongkir
    id_ongkir = int.parse(widget.ketPesanan.id_ongkir);

    setState(() {
      loading = false;
    });
  }

  bool apakahBeda = false;
  Future<Null> getDataPesananLatest() async {
    setState(() {
      loading = true;
    });

    var queryParameters = {'id_pesanan': widget.ketPesanan.id_pesanan};
    var uri = Uri.parse(BaseUrl.pesanan)
        .replace(queryParameters: queryParameters)
        .toString();
    final response = await http.get(uri);
    final data = jsonDecode(response.body);
    final dataPesanan = data['data_pesanan'];

    if (response.statusCode == 200) {
      print(dataPesanan);
      print(data['message']);
      dataPesanan.forEach((api) {
        final temp = new PesananModel(
            api['id_pesanan'],
            api['id_plg'],
            api['id_status'],
            api['id_ongkir'],
            api['id_metode_bayar'],
            api['alamat_pesanan'],
            api['nohp_pemesan'],
            api['waktu_pesan'],
            api['waktu_jemput'],
            api['waktu_antar'],
            api['catatan_pesanan'],
            api['total_tarif_pesanan']);

        // apakah data api sama dengan data sekarang?, jika beda ganti dan set true variabel apakahBeda
        if (widget.ketPesanan.id_status == temp.id_status) {
          print("sama");
        } else {
          print("beda");
          apakahBeda = true;
          widget.ketPesanan = temp;
        }
      });
    } else {
      print(dataPesanan);
      print(data['message']);
    }

    getDataDetailPesanan();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataDetailPesanan();
  }

  final GlobalKey<RefreshIndicatorState> _refresh =
      new GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        if (apakahBeda) {
          Navigator.pop(context, "reload");
        } else {
          Navigator.pop(context);
        }

        return Future.value(false);
      },
      child: Scaffold(
          key: _scaffoldState,
          appBar: AppBar(
            title: Text("Detail Pesanan"),
          ),
          body: RefreshIndicator(
            onRefresh: getDataPesananLatest,
            key: _refresh,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: loading
                  ? Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 16.0, right: 16.0, left: 16.0),
                          child: Column(
                            children: <Widget>[
                              heading("Pesanan"),
                              Divider(),
                              ketPesanan(),
                              Divider(),
                              heading("Keterangan Pesanan"),
                              Divider(),
                              ketPesanan2(),
                              Divider(),
                              heading("Item Pesanan"),
                              Divider(),
                              detailPesanan(),
                              Divider(),
                              rekap(),
                              Divider(),

                              // Divider(),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 9.0),
                                child: heading("Status Sepatu"),
                              ),
                              SizedBox(
                                child: Container(
                                  color: Colors.grey[300],
                                ),
                                height: 10.0,
                              ),
                              statusSepatu(),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          )),
    );
  }

  Widget heading(String str) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            height: 40.0,
            color: Colors.grey[300],
            child: Center(
                child: Text(
              str,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ))),
      ],
    );
  }

  Widget ketPesanan() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 3.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'ID Pesanan',
                  style: styleJudul,
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text("$ket1IdPesanan")
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Status Pesanan', style: styleJudul),
                SizedBox(
                  height: 3.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(15.0),
                    color: ket1StatusPesanan == "1"
                        ? Colors.orange[400]
                        : (ket1StatusPesanan == "2"
                            ? Colors.green[400]
                            : Colors.teal[400]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0.7, bottom: 0.7, left: 3.0, right: 3.0),
                      child: Text(
                          "Pesanan ${widget.listDataStatus[int.parse(ket1StatusPesanan) - 1].nama_status}",
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tanggal Pesan',
                  style: styleJudul,
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text("$ket1TglPesan")
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Waktu Pesan', style: styleJudul),
                SizedBox(
                  height: 3.0,
                ),
                Text("$ket1WktPesan WITA")
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Metode Pembayaran',
                  style: styleJudul,
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text(
                    "${widget.listDataMetod[int.parse(ket1MetodBayar) - 1].nama_metode}")
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('No. Handphone', style: styleJudul),
                SizedBox(
                  height: 3.0,
                ),
                Text("$ket1NoHp")
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget ketPesanan2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        alamatPesanan(),
        SizedBox(
          height: 10.0,
        ),
        tglWktJemput(),
        SizedBox(
          height: 10.0,
        ),
        tglWktAntar(),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget alamatPesanan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Alamat Pesanan',
          style: styleJudul,
        ),
        SizedBox(
          height: 3.0,
        ),
        Text(
          "${ket1AlamatPesanan}",
          textAlign: TextAlign.justify,
        )
      ],
    );
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
            Text("${ket2TglJemput}")
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Waktu Jemput', style: styleJudul),
            SizedBox(
              height: 3.0,
            ),
            Text("$ket2WktJemput WITA")
          ],
        )
      ],
    );
  }

  Widget tglWktAntar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Tanggal Antar',
              style: styleJudul,
            ),
            SizedBox(
              height: 3.0,
            ),
            Text("${ket2TglAntar}")
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('Waktu Antar', style: styleJudul),
            SizedBox(
              height: 3.0,
            ),
            Text("${ket2WktAntar} WITA")
          ],
        )
      ],
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

  Widget dataDetailPesanan() {
    var size = MediaQuery.of(context).size;

    List<Widget> rowDtlPesanan = [];
    var dtDbDj = List.from(widget.dtDbDetailJasa);

    rowDtlPesanan.clear();

    idJasa_DtlPesanan.forEach((key, value) {
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

  Widget statusSepatu() {
    final sizeScreen = MediaQuery.of(context).size;

    List<Widget> itemSepatu = [];

    for (DetailPesananModel item in listDtDetailPesanan) {
      var indexJasa =
          widget.dtDbDetailJasa[int.parse(item.id_detail_jasa) - 1].id_jasa;
      var namaJasa = widget.dtDbJasa[int.parse(indexJasa) - 1].nama_jasa;

      var namaDetailJasa = widget
          .dtDbDetailJasa[int.parse(item.id_detail_jasa) - 1].nama_detail_jasa;

      var namaStatus =
          widget.listDataStatus[int.parse(item.id_status) - 1].nama_status;

      var jasaDetailJasa = "$namaJasa - $namaDetailJasa";

      var fotoSblm =
          item.foto_sblm == "-" ? "default-mobile.png" : item.foto_sblm;

      itemSepatu.add(Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: sizeScreen.width / 4,
                  child: InkWell(
                    onTap: () {
                      detailSepatuPopUp(item);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Material(
                          elevation: 5.0,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              detailSepatuPopUp(item);
                            },
                            child: Container(
                              width: sizeScreen.width / 1.2,
                              // height: 80.0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0.0,
                          child: Material(
                            shadowColor: Colors.black,
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blue[400],
                            child: Container(
                              width: sizeScreen.width / 5,
                              height: sizeScreen.width / 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  BaseUrl.beforeAfter + fotoSblm,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0.0,
                          child: Material(
                            shadowColor: Colors.black,
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(15.0),
                            color: item.id_status == "1"
                                ? Colors.orange[400]
                                : Colors.green[400],
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("$namaStatus",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white)),
                            ),
                          ),
                        ),
                        Positioned(
                          left: sizeScreen.width / 4.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${item.merek_spt}",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Theme.of(context).primaryColor),
                              ),
                              jasaDetailJasa.length < 40
                                  ? Text("${jasaDetailJasa}",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12.0))
                                  : Text("${jasaDetailJasa}",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 10.0)),
                              Text("Warna ${item.warna_spt}",
                                  style: TextStyle(fontSize: 12.0)),
                              Text("Size ${item.size_spt}",
                                  style: TextStyle(fontSize: 12.0)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
          SizedBox(
            height: 3.0,
          )
        ],
      ));
    }

    return Column(
      children: itemSepatu,
    );
  }
}
