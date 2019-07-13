import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projek_ta/model/adminModel.dart';
import 'package:projek_ta/model/api.dart';
import 'package:projek_ta/model/artikelModel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;

class DetailArtikel extends StatefulWidget {
  final ArtikelModel artikelModel;
  final AdminModel adminModel;

  DetailArtikel(this.artikelModel, this.adminModel);

  @override
  _DetailArtikelState createState() => _DetailArtikelState();
}

class _DetailArtikelState extends State<DetailArtikel> {
  Timer _timer;

  tambahDilihat() {
    _timer = new Timer(Duration(seconds: 10), () async {
      final response = await http.post(BaseUrl.dilihat,
          body: {'id_artikel': widget.artikelModel.id_artikel});
      final dataBody = jsonDecode(response.body);
      print(dataBody['message']);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tambahDilihat();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.white,
      body: NestedScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: screenSize.height / 3.3,
              floating: false,
              pinned: true,
              title: Text("Artikel"),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                    // height: 150.0,
                    child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  fadeInCurve: Curves.easeIn,
                  fit: BoxFit.cover,
                  image: BaseUrl.url +
                      "doktersepatu/uploads/foto-artikel/${widget.artikelModel.foto_header}",
                )),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.artikelModel.judul_artikel,
                  textAlign: TextAlign.start,
                  textScaleFactor: 1.2,
                  style: TextStyle(
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900]),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.bookmark_border,
                          size: 12.0,
                          color: Colors.grey[500],
                        ),
                        Text(
                          widget.adminModel.nama_adm,
                          style: TextStyle(fontSize: 12.0),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: 12.0,
                          color: Colors.grey[500],
                        ),
                        Text(
                          widget.artikelModel.tgl_artikel,
                          style: TextStyle(fontSize: 12.0),
                        )
                      ],
                    ),
                  ],
                ),
                Divider(),
                Container(
                  child: HtmlWidget(
                    widget.artikelModel.isi_artikel,
                    webView: true,
                    bodyPadding: EdgeInsets.all(0.0),
                    textStyle: TextStyle(color: Colors.grey[800], height: 1.2),
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
