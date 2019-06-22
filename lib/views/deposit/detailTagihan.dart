import 'package:flutter/material.dart';

class DetailTagihan extends StatefulWidget {
  @override
  _DetailTagihanState createState() => _DetailTagihanState();
}

class _DetailTagihanState extends State<DetailTagihan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Tagihan")
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("Mantap")
          ],
        ),
      ),
    );
  }
}