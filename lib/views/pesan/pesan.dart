import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projek_ta/ui_pisah/itemJasa.dart';
import 'package:projek_ta/views/pesan/inputKetPesan.dart';

class Pesan extends StatefulWidget {
  @override
  _PesanState createState() => _PesanState();
}

class _PesanState extends State<Pesan> {
  int _itemCount = 0;
  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        persistentFooterButtons: <Widget>[
          Container(
            width: screenSize.width / 2,
            child: Text(
              "Total:  Rp.999.000",
              textAlign: TextAlign.left,
            ),
          ),
          MaterialButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => inputKetPesan()
            )),
            minWidth: screenSize.width / 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Color.fromARGB(255, 116, 150, 213),
            child: Row(
              children: <Widget>[Text("Lanjutkan"), Icon(Icons.chevron_right)],
            ),
            textColor: Colors.white,
          )
        ],
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                      title: new Text("Jasa Perawatan"),
                      children: List.generate(
                          5,
                          (i) => ItemJasa(
                                title: "Deep Clean",
                                subtitle: "Rp.25.000/pasang",
                              )),
                    ),
                    ExpansionTile(
                      title: new Text("Jasa Perbaikan"),
                      children: List.generate(
                          5,
                          (i) => ItemJasa(
                                title: "Ganti Sol",
                                subtitle: "Rp.25.000/pasang",
                              )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
