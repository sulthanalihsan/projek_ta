import 'package:flutter/material.dart';
import 'package:projek_ta/model/api.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:projek_ta/custom/formatUang.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class PesananTest extends StatelessWidget {
//   String idPlg;
//   PesananTest(this.idPlg);

//   @override
//   Widget build(BuildContext context) {
//     return Container(child: Text(idPlg));
//   }
// }

class PesananProses extends StatefulWidget {
  final String idPlg;

  PesananProses(this.idPlg);
  @override
  _PesananProsesState createState() => _PesananProsesState();
}

class _PesananProsesState extends State<PesananProses> {
  getIdPlg() {
    setState(() {
      getData();
    });
  }

  var loading = false;
  getData() async {
    setState(() {
      loading = true;
    });

    var queryParameters;
    setState(() {
      queryParameters = {'id_plg': widget.idPlg};
    });
    var uri = Uri.parse(BaseUrl.pesananProses)
        .replace(queryParameters: queryParameters)
        .toString();
    final response = await http.get(uri);
    final data = jsonDecode(response.body);
    final dataPesanan = data['data_pesanan'];

    if (response.statusCode == 200) {
      print(data['message']);
      print(widget.idPlg);
      print(uri);
      print(dataPesanan);
    } else {
      print(data['message']);
      print(widget.idPlg);
      print(uri);
      print(dataPesanan);
    }

    setState(() {
      loading = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
    getIdPlg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Pesanan Proses +${widget.idPlg}"),
      ),
    );
  }
}
