import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  int pilihanUmur;
  int pilihanTglLhr;

  Map<String, int> pilihan = {"pilihUmur": 0, "pilihTglLahir": 0};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Umur"),
              RadioListTile(
                title: Text("20"),
                value: 20,
                groupValue: pilihan["pilihUmur"],
                onChanged: (value) {
                  setState(() {
                    pilihan["pilihUmur"] = value;
                  });
                },
              ),
              RadioListTile(
                title: Text("21"),
                value: 21,
                groupValue: pilihan["pilihUmur"],
                onChanged: (value) {
                  setState(() {
                    pilihan["pilihUmur"] = value;
                  });
                },
              ),
              Text("Tanggal Lahir"),
              RadioListTile(
                title: Text("13"),
                value: 13,
                groupValue: pilihan["pilihTglLahir"],
                onChanged: (value) {
                  setState(() {
                    pilihan["pilihTglLahir"] = value;
                  });
                },
              ),
              RadioListTile(
                title: Text("19"),
                value: 19,
                groupValue: pilihan["pilihTglLahir"],
                onChanged: (value) {
                  setState(() {
                    pilihan["pilihTglLahir"] = value;
                  });
                },
              ),
              FlatButton(
                child: Text("Tombol"),
                onPressed: (){
                  print(pilihan.toString());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
