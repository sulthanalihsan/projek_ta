import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              Text("Dokter Sepatu Apps v.1"),
              SizedBox(
                height: 5.0,
              ),
              Text("by Sulthan"),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Folow Me",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5.0,
              ),
              GestureDetector(
                  child: Text("Github",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue)),
                  onTap: () {
                    launch('https://www.github.com/sulthanalihsan');
                  }),
              SizedBox(
                height: 2.0,
              ),
              GestureDetector(
                  child: Text("Instagram",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue)),
                  onTap: () {
                    launch('https://www.instagram.com/sulthanalihsan');
                  }),
              SizedBox(
                height: 2.0,
              ),
              GestureDetector(
                  child: Text("Linkedin",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue)),
                  onTap: () {
                    launch('https://www.linkedin.com/in/sulthanalihsan/');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
