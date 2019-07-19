import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:projek_ta/model/adminModel.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/model/artikelModel.dart';
import 'package:projek_ta/views/artikel/detailArtikel.dart';
import 'package:projek_ta/views/artikel/semuarArtikel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;

class SemuaArtikel extends StatefulWidget {
  @override
  _SemuaArtikelState createState() => _SemuaArtikelState();
}

class _SemuaArtikelState extends State<SemuaArtikel> {
  var loading = false;
  var listDataArtikel = List<ArtikelModel>();
  var listSearch = List<ArtikelModel>();
  final listDataAdmin = List<AdminModel>();
  Future<void> _getData() async {
    listDataArtikel.clear();

    setState(() {
      loading = true;
    });

    var response = await http.get(BaseUrl.artikel);
    var dataBody = jsonDecode(response.body);
    final dataArtikel = dataBody['data_artikel'];

    if (response.statusCode == 200) {
      setState(() {
        for (Map i in dataArtikel) {
          listDataArtikel.add(ArtikelModel.fromJson(i));
          // loading = false;
        }
      });
      // dataArtikel.forEach((api) {
      //   final temp = new ArtikelModel(
      //       api['id_artikel'],
      //       api['id_adm'],
      //       api['judul_artikel'],
      //       api['tgl_artikel'],
      //       api['isi_artikel'],
      //       api['foto_header']);
      //   listDataArtikel.add(temp);
      // });
      // listDataArtikel = listDataArtikel.reversed.toList();
    }

    response = await http.get(BaseUrl.admin);
    dataBody = jsonDecode(response.body);
    final dataAdmin = dataBody['data_admin'];

    if (response.statusCode == 200) {
      dataAdmin.forEach((api) {
        final temp = new AdminModel(
            api['id_adm'], api['email_adm'], api['nama_adm'], api['foto_adm']);

        listDataAdmin.add(temp);
      });
    }

    setState(() {
      loading = false;
    });
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    listSearch.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    listDataArtikel.forEach((f) {
      if (f.judul_artikel.toLowerCase().contains(text)) {
        setState(() {
          listSearch.add(f);
        });
      }
    });

    // setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    listSearch.clear();
  }

  bool munculSearch = false;

  @override
  Widget build(BuildContext context) {
    final _refresh = new GlobalKey<RefreshIndicatorState>();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: munculSearch
            ? TextField(
                controller: controller,
                onChanged: onSearch,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search",
                    border: InputBorder.none),
              )
            : Text("Semua Artikel"),
        actions: <Widget>[
          munculSearch
              ? IconButton(
                  onPressed: () => setState(() {
                        controller.clear();
                        onSearch('');
                        munculSearch = false;
                      }),
                  icon: Icon(Icons.close),
                )
              : IconButton(
                  onPressed: () => setState(() {
                        munculSearch = true;
                      }),
                  icon: Icon(Icons.search),
                ),
        ],
      ),
      body: RefreshIndicator(
        key: _refresh,
        onRefresh: _getData,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.only(right: 14.0, left: 14.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listSearch == 0 || controller.text.isEmpty
                      ? listDataArtikel.length
                      : listSearch.length,
                  itemBuilder: (context, i) {
                    final item = listSearch == 0 || controller.text.isEmpty
                        ? listDataArtikel[i]
                        : listSearch[i];
                    var tempTglArtikel = DateTime.parse(item.tgl_artikel);
                    var frTglArtikel =
                        DateFormat('d MMMM yyyy').format(tempTglArtikel);
                    return Card(
                      elevation: 3.0,
                      margin: EdgeInsets.only(top: 14.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailArtikel(
                                      item,
                                      listDataAdmin[
                                          int.parse(item.id_adm) - 1])));
                        },
                        child: Container(
                          // height: screenSize.height / 6,
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                      item.judul_artikel,
                                      // textScaleFactor: 1.2,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.bookmark_border,
                                            size: 16.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Text(
                                          listDataAdmin[
                                                  int.parse(item.id_adm) - 1]
                                              .nama_adm,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.access_time,
                                            size: 16.0,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        Text(
                                          "$frTglArtikel",
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                    width: screenSize.height / 8,
                                    height: screenSize.height / 8,
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      fadeInCurve: Curves.easeIn,
                                      fit: BoxFit.cover,
                                      image: BaseUrl.fotoArtikel + item.foto_header,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
