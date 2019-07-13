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

final List<ArtikelModel> listDataArtikelFav = [];
final List<AdminModel> adminListGlobal = [];
final List<String> imgList = [];

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class Artikel extends StatefulWidget {
  @override
  _ArtikelState createState() => _ArtikelState();
}

class _ArtikelState extends State<Artikel> {
  var loading = false;
  final listDataArtikelTerbaru = List<ArtikelModel>();
  final listDataAdmin = List<AdminModel>();

  Future<void> _getData() async {
    listDataArtikelFav.clear();
    imgList.clear();
    listDataArtikelTerbaru.clear();
    listDataAdmin.clear();

    setState(() {
      loading = true;
    });

    var response = await http.get(BaseUrl.artikelTerbaru);
    var dataBody = jsonDecode(response.body);
    final dataArtikelTerbaru = dataBody['data_artikel'];

    if (response.statusCode == 200) {
      dataArtikelTerbaru.forEach((api) {
        final temp = new ArtikelModel(
            api['id_artikel'],
            api['id_adm'],
            api['judul_artikel'],
            api['tgl_artikel'],
            api['isi_artikel'],
            api['foto_header']);
        listDataArtikelTerbaru.add(temp);
      });
    }

    response = await http.get(BaseUrl.artikelFavorit);
    dataBody = jsonDecode(response.body);
    final dataArtikelFavorit = dataBody['data_artikel'];
    if (response.statusCode == 200) {
      dataArtikelFavorit.forEach((api) {
        final temp = new ArtikelModel(
            api['id_artikel'],
            api['id_adm'],
            api['judul_artikel'],
            api['tgl_artikel'],
            api['isi_artikel'],
            api['foto_header']);

        listDataArtikelFav.add(temp);
        imgList.add(BaseUrl.url +
            "doktersepatu/uploads/foto-artikel/" +
            api['foto_header']);
      });
    }

    response = await http.get(BaseUrl.admin);
    dataBody = jsonDecode(response.body);
    final dataAdmin = dataBody['data_admin'];

    if (response.statusCode == 200) {
      dataAdmin.forEach((api) {
        final temp = new AdminModel(
            api['id_adm'], api['email_adm'], api['nama_adm'], api['foto_adm']);

        listDataAdmin.add(temp);
        adminListGlobal.add(temp);
      });
    }

    setState(() {
      loading = false;
    });

    // print(dataBody);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  int _current = 0;
  changeIndex(int index) {
    setState(() {
      _current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _refresh = new GlobalKey<RefreshIndicatorState>();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text("Artikel"),
          centerTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh: _getData,
            key: _refresh,
            child: loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CarouselWithIndicator(),
                      ListTile(
                        // contentPadding: Edge,
                        title: Text(
                          "Artikel Terbaru",
                        ),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SemuaArtikel())),
                                child: Text(
                                  "lihat semua",
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey[500])
                            ]),
                      ),
                      Flexible(
                        // fit: FlexFit.tight,
                        child: Container(
                          // height: 100.0,
                          padding: EdgeInsets.only(right: 14.0, left: 14.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listDataArtikelTerbaru.length,
                            itemBuilder: (context, i) {
                              final item = listDataArtikelTerbaru[i];
                              var tempTglArtikel =
                                  DateTime.parse(item.tgl_artikel);
                              var frTglArtikel = DateFormat('d MMMM yyyy')
                                  .format(tempTglArtikel);
                              return Card(
                                elevation: 3.0,
                                margin: EdgeInsets.only(bottom: 12.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailArtikel(
                                                item,
                                                listDataAdmin[
                                                    int.parse(item.id_adm) -
                                                        1])));
                                  },
                                  child: Container(
                                    // height: screenSize.height / 6,
                                    padding: EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5.0),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5.0),
                                                    child: Icon(
                                                      Icons.bookmark_border,
                                                      size: 16.0,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    listDataAdmin[int.parse(
                                                                item.id_adm) -
                                                            1]
                                                        .nama_adm,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5.0),
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
                                                        fontWeight:
                                                            FontWeight.w500),
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
                                                image: BaseUrl.url +
                                                    "doktersepatu/uploads/foto-artikel/${item.foto_header}",
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
                      )
                    ],
                  )));
  }
}

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
              // contentPadding: Edge,
              title: Text("Artikel Favorit"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(
                  imgList,
                  (index, url) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Color.fromARGB(255, 33, 86, 168)
                              : Color.fromARGB(255, 116, 150, 213)),
                    );
                  },
                ),
              )),
          CarouselSlider(
              pauseAutoPlayOnTouch: Duration(seconds: 4),
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 1.9,
              viewportFraction: 1.0,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              items: map<Widget>(
                imgList,
                (index, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailArtikel(
                                  listDataArtikelFav[index],
                                  adminListGlobal[int.parse(
                                          listDataArtikelFav[index].id_adm) -
                                      1])));
                      // print(artikelListGlobal[index].judul_artikel);
                    },
                    child: Container(
                      // height: 150.0,
                      // margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        child: Stack(children: <Widget>[
                          FadeInImage.memoryNetwork(
                              image: i,
                              fit: BoxFit.cover,
                              width: 1000.0,
                              placeholder: kTransparentImage,
                              fadeInCurve: Curves.easeIn),
                          // Image.network(i, fit: BoxFit.cover, width: 1000.0),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                listDataArtikelFav[index].judul_artikel,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              )),
        ]);
  }
}
