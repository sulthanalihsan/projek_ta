import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:projek_ta/model/detailJasaModel.dart';
import 'package:projek_ta/model/jasaModel.dart';
import 'package:projek_ta/model/ongkirModel.dart';
import 'package:projek_ta/ui_pisah/itemJasa.dart';
import 'package:projek_ta/views/pesan/inputKetPesan.dart';

import 'dart:convert';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:projek_ta/model/api.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:projek_ta/custom/formatUang.dart';

class Pesan extends StatefulWidget {
  @override
  _PesanState createState() => _PesanState();
}

class _PesanState extends State<Pesan> {
  FormatUang frUang = new FormatUang();
  int _itemCount = 0;
  var top = 0.0;
  bool tilePerawatan = false;
  bool tileReparasi = false;

  final dtJasaPerawatan = new List<JasaModel>();
  final dtJasaReparasi = new List<JasaModel>();
  final dtDetailJasa = new List<DetailJasaModel>();
  final dtOngkir = new List<OngkirModel>();

  Map<String, dynamic> idDetailJasa = {};
  Map<String, int> tarifJasa = {};
  int totalTemp = 0;

  var loading = false;
  final _refresh = GlobalKey<RefreshIndicatorState>();

  Future<void> _fetchData() async {
    setState(() {
      //saat masih dalam proses mencari loadingnya jalan
      loading = true;
    });

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
      });
      dataReparasiAPI.forEach((api) {
        final temp =
            new JasaModel(api['id_jasa'], api['id_kategori'], api['nama_jasa']);
        dtJasaReparasi.add(temp);
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

    setState(() {
      //saat data sudah dapat loadingnya stop
      loading = false;
    });
  }

  Widget dataJasa() {
    List<Padding> listDataJasa = [];
    for (JasaModel item in dtJasaPerawatan) {
      listDataJasa.add(Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(item.nama_jasa,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400)),
              Icon(
                Icons.local_taxi,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
          Divider(
            height: 10.0,
            color: Theme.of(context).primaryColor,
          ),
        ]),
      ));
    }

    return Column(
      children: listDataJasa,
    );
  }

  Widget detailJasa() {
    List<ListTile> listDetailJasa = [];
    FormatUang frUang = new FormatUang();

    for (DetailJasaModel item in dtDetailJasa) {
      listDetailJasa.add(ListTile(
        title: Text(
          item.nama_detail_jasa,
          style: TextStyle(fontSize: 20.0),
        ),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text("${frUang.uangFormat(item.tarif)}/pasang",
                    style: TextStyle(fontSize: 14.0)),
              ),
              Text(
                "cth: sepatu flat, cewe, anak-anak",
                style: TextStyle(fontSize: 10.0),
              ),
            ]),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            idDetailJasa[item.id_detail_jasa] != 0
                // _itemCount != 0
                ? IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red[200],
                      size: 28.0,
                    ),
                    onPressed: () => setState(() {
                          idDetailJasa[item.id_detail_jasa]--;
                          totalTemp -= tarifJasa[item.id_detail_jasa];
                        }),
                  )
                : Container(),
            Text(
              idDetailJasa[item.id_detail_jasa].toString(),
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
            ),
            IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).primaryColor,
                  size: 28.0,
                ),
                onPressed: () => setState(() {
                      idDetailJasa[item.id_detail_jasa]++;
                      totalTemp += tarifJasa[item.id_detail_jasa];
                    }))
          ],
        ),
      ));
    }

    return Column(
      children: listDetailJasa,
    );
  }

  Widget dataJasaPerawatanDanDetail() {
    FormatUang frUang = new FormatUang();
    List<Column> columnJasaDanDetail = [];

    for (JasaModel itemPerawatan in dtJasaPerawatan) {
      Padding padList;
      List<Widget> tileDetailJasa = [];

      padList = Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(itemPerawatan.nama_jasa,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400)),
            ],
          ),
          Divider(
            height: 10.0,
            color: Theme.of(context).primaryColor,
          ),
        ]),
      );

      for (DetailJasaModel itemDetail in dtDetailJasa) {
        if (itemPerawatan.id_jasa == itemDetail.id_jasa) {
          tileDetailJasa.add(ListTile(
            title: Text(
              itemDetail.nama_detail_jasa,
              style: TextStyle(fontSize: 20.0),
            ),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Text("${frUang.uangFormat(itemDetail.tarif)}/pasang",
                        style: TextStyle(fontSize: 14.0)),
                  ),
                  Text(
                    "${itemDetail.deskripsi}",
                    style: TextStyle(fontSize: 10.0),
                  ),
                ]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                idDetailJasa[itemDetail.id_detail_jasa] != 0
                    // _itemCount != 0
                    ? IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red[200],
                          size: 28.0,
                        ),
                        onPressed: () => setState(() {
                              idDetailJasa[itemDetail.id_detail_jasa]--;
                              totalTemp -= tarifJasa[itemDetail.id_detail_jasa];
                            }),
                      )
                    : Container(),
                Text(
                  idDetailJasa[itemDetail.id_detail_jasa].toString(),
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
                ),
                IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).primaryColor,
                      size: 28.0,
                    ),
                    onPressed: () => setState(() {
                          idDetailJasa[itemDetail.id_detail_jasa]++;
                          totalTemp += tarifJasa[itemDetail.id_detail_jasa];
                        }))
              ],
            ),
          ));
        }
      }

      columnJasaDanDetail.add(Column(
        children: <Widget>[
          padList,
          Column(
            children: tileDetailJasa,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 14.0),
          )
        ],
      ));
    }

    return Column(
      children: columnJasaDanDetail,
    );
  }

  Widget dataJasaReparasiDanDetail() {
    FormatUang frUang = new FormatUang();
    List<Column> columnJasaDanDetail = [];

    for (JasaModel itemPerawatan in dtJasaReparasi) {
      Padding padList;
      List<Widget> tileDetailJasa = [];

      padList = Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(itemPerawatan.nama_jasa,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400)),
            ],
          ),
          Divider(
            height: 10.0,
            color: Theme.of(context).primaryColor,
          ),
        ]),
      );

      for (DetailJasaModel itemDetail in dtDetailJasa) {
        if (itemPerawatan.id_jasa == itemDetail.id_jasa) {
          tileDetailJasa.add(ListTile(
            title: Text(
              itemDetail.nama_detail_jasa,
              style: TextStyle(fontSize: 20.0),
            ),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Text("${frUang.uangFormat(itemDetail.tarif)}/pasang",
                        style: TextStyle(fontSize: 14.0)),
                  ),
                  Text(
                    itemDetail.deskripsi,
                    style: TextStyle(fontSize: 10.0),
                  ),
                ]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                idDetailJasa[itemDetail.id_detail_jasa] != 0
                    // _itemCount != 0
                    ? IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red[200],
                          size: 28.0,
                        ),
                        onPressed: () => setState(() {
                              idDetailJasa[itemDetail.id_detail_jasa]--;
                              totalTemp -= tarifJasa[itemDetail.id_detail_jasa];
                            }),
                      )
                    : Container(),
                Text(
                  idDetailJasa[itemDetail.id_detail_jasa].toString(),
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
                ),
                IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).primaryColor,
                      size: 28.0,
                    ),
                    onPressed: () => setState(() {
                          idDetailJasa[itemDetail.id_detail_jasa]++;
                          totalTemp += tarifJasa[itemDetail.id_detail_jasa];
                        }))
              ],
            ),
          ));
        }
      }

      columnJasaDanDetail.add(Column(
        children: <Widget>[
          padList,
          Column(
            children: tileDetailJasa,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 14.0),
          )
        ],
      ));
    }

    return Column(
      children: columnJasaDanDetail,
    );
  }

  final _scaffoldState = new GlobalKey<ScaffoldState>();
  _snackBarShow(String value) {
    _scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(value),
      backgroundColor: Colors.red,
      // duration: Duration(seconds: 1),
      action: SnackBarAction(
        textColor: Colors.white,
        label: "OK",
        onPressed: () {},
      ),
    ));
  }

  _alertDialogShow() {
    final sizeScreen = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Apakah anda yakin?"),
            content: Container(
              height: sizeScreen.height / 10,
              child: Center(child: Text("Cek kembali jasa yang anda pilih")),
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
                child: new Text("Lanjut"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => inputKetPesan(
                              idDetailJasa, dtOngkir, dtDetailJasa)));
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffoldState,
        persistentFooterButtons: <Widget>[
          loading
              ? null
              : Row(
                  children: <Widget>[
                    Container(
                      width: screenSize.width / 2,
                      child: Text(
                        "Total:  ${frUang.uangFormat(totalTemp.toString())}",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        print(idDetailJasa);
                        bool isPilihJasaKosong =
                            idDetailJasa.values.every((value) => value == 0);
                        print(isPilihJasaKosong);
                        if (isPilihJasaKosong) {
                          _snackBarShow("Silahkan pilih jasa terlebih dahulu");
                        } else {
                          _alertDialogShow();
                        }
                      },
                      minWidth: screenSize.width / 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Color.fromARGB(255, 116, 150, 213),
                      child: Row(
                        children: <Widget>[
                          Text("Lanjutkan"),
                          Icon(Icons.chevron_right)
                        ],
                      ),
                      textColor: Colors.white,
                    )
                  ],
                )
        ],
        body: RefreshIndicator(
          onRefresh: _fetchData,
          key: _refresh,
          child: loading
              ? ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text("Loading")
                            ]),
                      ),
                    )
                  ],
                )
              : NestedScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: screenSize.height / 3.5,
                        floating: false,
                        pinned: true,
                        title: Text("Pilih Jasa"),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            height: 150.0,
                            color: Color.fromARGB(255, 116, 150, 213),
                            child: Image.network(
                              "https://images.unsplash.com/photo-1462927114214-6956d2fddd4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=749&q=80",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    ];
                  },
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ExpansionTile(
                                onExpansionChanged: (bool expanded) =>
                                    setState(() {
                                      this.tilePerawatan = expanded;
                                    }),
                                title: new Text(
                                  "Jasa Perawatan",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: tilePerawatan
                                          ? Colors.blue[900]
                                          : Colors.black),
                                ),
                                children: <Widget>[
                                  // dataJasa(),
                                  // detailJasa(),
                                  dataJasaPerawatanDanDetail()
                                ]),
                            ExpansionTile(
                                onExpansionChanged: (bool expanded) =>
                                    setState(() {
                                      this.tileReparasi = expanded;
                                    }),
                                title: new Text(
                                  "Jasa Reparasi",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: tileReparasi
                                          ? Colors.blue[900]
                                          : Colors.black),
                                ),
                                children: <Widget>[
                                  // dataJasa(),
                                  // detailJasa(),
                                  dataJasaReparasiDanDetail()
                                ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
