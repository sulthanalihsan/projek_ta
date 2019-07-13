import 'package:flutter/material.dart';

class TentangKami extends StatefulWidget {
  @override
  _TentangKamiState createState() => _TentangKamiState();
}

class _TentangKamiState extends State<TentangKami> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                './img/logods.png',
                width: 140.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text("Dokter Sepatu Apps"),
              Text("Verson 1.1"),
            ],
          ),
        ),
      ),
    );
  }
}

