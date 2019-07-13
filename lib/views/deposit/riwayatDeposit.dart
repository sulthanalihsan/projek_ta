import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:projek_ta/custom/formatUang.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/model/depositModel.dart';
import 'package:projek_ta/model/detailJasaModel.dart';
import 'package:projek_ta/model/jasaModel.dart';
import 'package:projek_ta/model/metodeBayarModel.dart';
import 'package:projek_ta/model/ongkirModel.dart';
import 'package:projek_ta/model/rekeningModel.dart';
import 'package:projek_ta/model/statusModel.dart';
import 'package:projek_ta/views/deposit/detailTagihan.dart';
import 'package:projek_ta/views/pesan/detailPesanan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RiwayatDeposit extends StatefulWidget {
  @override
  _RiwayatDepositState createState() => _RiwayatDepositState();
}

class _RiwayatDepositState extends State<RiwayatDeposit> {
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

    getDataRekening();
  }

  final listDataRekening = new List<RekeningModel>();
  getDataRekening() async {
    listDataRekening.clear();

    final response = await http.get(BaseUrl.rekening);
    final data = jsonDecode(response.body);
    final dataRekening = data["data_rekening"];
    dataRekening.forEach((api) {
      final temp = RekeningModel(api['id_rek_bank'], api['nama_bank'],
          api['atas_nama_rek'], api['no_rek'], api['logo_bank']);
      listDataRekening.add(temp);
    });

    getDataDeposit();
  }

  var dataDepositPending = new List<DepositModel>();
  var dataDepositSelesai = new List<DepositModel>();

  getDataDeposit() async {
    dataDepositPending.clear();

    var queryParameters = {'id_plg': idPlg};
    var uri = Uri.parse(BaseUrl.deposit)
        .replace(queryParameters: queryParameters)
        .toString();
    final response = await http.get(uri);
    final data = jsonDecode(response.body);
    final dataDeposit = data['data_deposit'];

    if (response.statusCode == 200) {
      dataDeposit.forEach((api) {
        final temp = new DepositModel(
            api['id_deposit'],
            api['id_plg'],
            api['id_rek_bank'],
            api['id_status'],
            api['jml_deposit'],
            api['waktu_deposit'],
            api['kode_unik']);

        if (api['id_status'] == "1") {
          dataDepositPending.add(temp);
        } else {
          dataDepositSelesai.add(temp);
        }
      });
      print(data['message']);
    } else {
      print(data['message']);
    }

    //membalik list yg terbaru diatas karena dari api nya ascending
    dataDepositPending = dataDepositPending.reversed.toList();
    dataDepositSelesai = dataDepositSelesai.reversed.toList();

    setState(() {
      loading = false;
    });
  }

  final _refresh = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Deposit"),
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
        onRefresh: getPref,
        key: _refresh,
        child: loading
            ? ListView(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
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
                                "PENDING",
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
                        children: [
                          wgDeposit(dataDepositPending),
                          wgDeposit(dataDepositSelesai),
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

  Widget wgDeposit(List<DepositModel> list) {
    TextStyle styleBiasa = TextStyle(fontSize: 12.0);
    final screenSize = MediaQuery.of(context).size;
    List<Widget> listDtDeposit = [];
    print(dataDepositPending);

    for (DepositModel item in list) {
      var totalNominal =
          int.parse(item.jml_deposit) + int.parse(item.kode_unik);
      var totalNominalFormat = fr.uangFormat(totalNominal.toString());

      listDtDeposit.add(Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailTagihan(
                          item,
                          listDataRekening[int.parse(item.id_rek_bank)-1],
                          false)));
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
                              "ID Deposit",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0),
                            ),
                            Text(
                              "Status",
                              style: styleBiasa,
                            ),
                            Text(
                              "Waktu Tagihan",
                              style: styleBiasa,
                            ),
                            Text("Nominal Tagihan", style: styleBiasa),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(" : ${item.id_deposit}", style: styleBiasa),
                            Row(children: <Widget>[
                              Text(" : ", style: styleBiasa),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: item.id_status == "1"
                                      ? Colors.orange[400]
                                      : Colors.green[400],
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
                            Text(" :  ${item.waktu_deposit} WITA",
                                style: styleBiasa),
                            Text(" : $totalNominalFormat", style: styleBiasa),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider()
        ],
      ));
      // print(item.idPesanan);
    }

    if (listDtDeposit.length == 0) {
      print("data 0");
      listDtDeposit.add(Container(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Center(child: Text("Data Tidak Ada")),
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        shrinkWrap: true,
        children: listDtDeposit,
      ),
    );
  }
}
