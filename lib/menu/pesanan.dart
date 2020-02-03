import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:projek_ta/custom/formatUang.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/model/detailJasaModel.dart';
import 'package:projek_ta/model/jasaModel.dart';
import 'package:projek_ta/model/metodeBayarModel.dart';
import 'package:projek_ta/model/ongkirModel.dart';
import 'package:projek_ta/model/pesananModel.dart';
import 'package:projek_ta/model/statusModel.dart';
import 'package:projek_ta/views/pesan/detailPesanan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Pesanan extends StatefulWidget {
  @override
  _PesananState createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  FormatUang fr = new FormatUang();
  String idPlg;

  Future<void> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idPlg = preferences.getString("idPlg");
    });
    getDataStatus();
  }

  var loading = false;

  final listDataStatus = new List<StatusModel>();
  getDataStatus() async {
    listDataStatus.clear();

    setState(() {
      loading = true;
    });

    final response = await http.get(BaseUrl.status);
    final data = jsonDecode(response.body);
    final dataStatus = data["data_status"];
    dataStatus.forEach((api) {
      final temp = new StatusModel(api['id_status'], api['nama_status']);
      listDataStatus.add(temp);
    });

    getDataMetod();
  }

  final listDataMetod = new List<MetodeBayarModel>();
  getDataMetod() async {
    listDataMetod.clear();

    final response = await http.get(BaseUrl.metode);
    final data = jsonDecode(response.body);
    final dataMetode = data["data_metode_bayar"];
    dataMetode.forEach((api) {
      final temp =
          new MetodeBayarModel(api['id_metode_bayar'], api['nama_metode']);
      listDataMetod.add(temp);
    });

    getDataPesananProses();
  }

  final dataPesananProsesPlg = new List<PesananModel>();
  getDataPesananProses() async {
    dataPesananProsesPlg.clear();

    var queryParameters = {'id_plg': idPlg};
    var uri = Uri.parse(BaseUrl.pesananProses)
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
        dataPesananProsesPlg.add(temp);
      });
      print(dataPesananProsesPlg);
    } else {
      print(dataPesanan);
      print(data['message']);
    }

    getDataPesananSelesai();
  }

  final dataPesananSelesaiPlg = new List<PesananModel>();
  getDataPesananSelesai() async {
    dataPesananSelesaiPlg.clear();

    var queryParameters = {'id_plg': idPlg};
    var uri = Uri.parse(BaseUrl.pesananSelesai)
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
        dataPesananSelesaiPlg.add(temp);
      });
      print(dataPesananSelesaiPlg);
    } else {
      print(dataPesanan);
      print(data['message']);
    }

    _fetchData();
  }

  final dtJasaPerawatan = new List<JasaModel>();
  final dtJasaReparasi = new List<JasaModel>();
  final dtDetailJasa = new List<DetailJasaModel>();
  final dtOngkir = new List<OngkirModel>();

  final dtDbJasa = new List<JasaModel>();

  Map<String, dynamic> idDetailJasa = {};
  Map<String, int> tarifJasa = {};
  int totalTemp = 0;

  Future<void> _fetchData() async {
    final response = await http.get(BaseUrl.jasa);
    final data = jsonDecode(response.body);
    final dataPerawatanAPI = data['data_jasa_perawatan'];
    final dataReparasiAPI = data['data_jasa_reparasi'];
    final detailJasaAPI = data['data_detail_jasa'];

    if (response.statusCode == 200) {
      dataPerawatanAPI.forEach((api) {
        final temp =
            new JasaModel(api['id_jasa'], api['id_kategori'], api['nama_jasa']);
        dtJasaPerawatan.add(temp);
        dtDbJasa.add(temp);
      });
      dataReparasiAPI.forEach((api) {
        final temp =
            new JasaModel(api['id_jasa'], api['id_kategori'], api['nama_jasa']);
        dtJasaReparasi.add(temp);
        dtDbJasa.add(temp);
      });

      detailJasaAPI.forEach((api) {
        final temp = new DetailJasaModel(
            api['id_detail_jasa'],
            api['id_jasa'],
            api['nama_detail_jasa'],
            api['tarif'],
            api['deskripsi'],
            api['foto']);
        dtDetailJasa.add(temp);
        idDetailJasa[api['id_detail_jasa']] = 0;
        tarifJasa[api['id_detail_jasa']] = int.parse(api['tarif']);
      });
    }



    final responseOngkir = await http.get(BaseUrl.ongkir);
    final dataOngkir = jsonDecode(responseOngkir.body);
    if (responseOngkir.statusCode == 200) {
      dataOngkir['data_ongkir'].forEach((api) {
        final temp = new OngkirModel(
            api['id_ongkir'], api['kecamatan'], api['tarif_ongkir']);
        dtOngkir.add(temp);
      });
    }

    print("INI DATA PERAWATAN");
    print(dtJasaPerawatan[0].nama_jasa);
    print("DATA ONGKIR");
    print(dtOngkir[0].kecamatan);

    setState(() {
      loading = false;
    });
  }

  final _refresh = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChannels.lifecycle.setMessageHandler((msg) {
      debugPrint("$msg");
      if (msg == "AppLifecycleState.resumed") {
        print("DIULANGI");
        _refresh.currentState.show();
        // getPref();
      }
    });

    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesanan"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _refresh.currentState.show();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refresh,
        onRefresh: getPref,
        child: loading
            ? ListView(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              )
            : DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints:
                          BoxConstraints(maxHeight: 150.0, minHeight: 60.0),
                      child: Material(
                        color: Colors.white,
                        child: TabBar(
                          indicatorColor: Theme.of(context).primaryColor,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Theme.of(context).primaryColor,
                          tabs: [
                            Tab(
                              child: Text(
                                "PROSES",
                                style: TextStyle(fontSize: 17.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "SELESAI",
                                style: TextStyle(fontSize: 17.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        // physics: ScrollPhysics(),
                        children: [
                          wgPesanan(dataPesananProsesPlg),
                          wgPesanan(dataPesananSelesaiPlg),
                          // wgPesananSelesai()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget wgPesanan(List<PesananModel> list) {
    TextStyle styleBiasa = TextStyle(fontSize: 12.0);
    final screenSize = MediaQuery.of(context).size;
    List<Widget> listColumnDtPesanan = [];
    print(dataPesananProsesPlg);

    for (PesananModel item in list) {
      listColumnDtPesanan.add(Column(
        children: <Widget>[
          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPesanan(item, listDataStatus,
                          listDataMetod, dtOngkir, dtDbJasa, dtDetailJasa)));

              if (result == "reload") {
                _refresh.currentState.show();
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text("Status Berubah"),
                  ));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    height: screenSize.height / 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "ID Pesanan",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0),
                            ),
                            Text(
                              "Status",
                              style: styleBiasa,
                            ),
                            Text(
                              "Pembayaran",
                              style: styleBiasa,
                            ),
                            Text("Waktu Jemput", style: styleBiasa),
                            Text("Alamat Jemput", style: styleBiasa),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(" :  ${item.id_pesanan}", style: styleBiasa),
                            Row(children: <Widget>[
                              Text(" : ", style: styleBiasa),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: item.id_status == "1"
                                      ? Colors.orange[400]
                                      : (item.id_status == "2"
                                          ? Colors.green[400]
                                          : Colors.teal[400]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.7,
                                        bottom: 0.7,
                                        left: 3.0,
                                        right: 3.0),
                                    child: Text(
                                        listDataStatus[
                                                int.parse(item.id_status) - 1]
                                            .nama_status,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white)),
                                  ),
                                ),
                              )
                            ]),
                            Text(
                                " :  ${listDataMetod[int.parse(item.id_metode_bayar) - 1].nama_metode}",
                                style: styleBiasa),
                            Text(" :  ${item.waktu_jemput} WITA",
                                style: styleBiasa),
                            Text(
                                " :  ${item.alamat_pesanan.substring(0, 25)}.....",
                                style: styleBiasa),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      // color: Colors.red,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Center(
                            child: Text(
                          "${fr.formatSimbolUjung(item.total_tarif_pesanan)}",
                          style: TextStyle(fontSize: 15.0),
                        )),
                      ),
                    ))
              ],
            ),
          ),
          Divider()
        ],
      ));
      // print(item.idPesanan);
    }

    if (listColumnDtPesanan.length == 0) {
      listColumnDtPesanan.add(Container(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Center(child: Text("Data Tidak Ada")),
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        shrinkWrap: true,
        children: listColumnDtPesanan,
      ),
    );
  }
}
