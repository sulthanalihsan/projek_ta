import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projek_ta/main.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final Color warnaPrimary = Color.fromARGB(255, 116, 150, 213);
  final TextStyle styleJudul = TextStyle(
      color: Color.fromARGB(255, 116, 150, 213), fontWeight: FontWeight.bold);

  String metodBayar = "";
  _pilihMetodBayar(String value) {
    setState(() {
      metodBayar = value;
    });
  }

  _aksiFloatingButton() {
    if (metodBayar.isNotEmpty) {
      print(metodBayar);
      // Navigator.popUntil(context, ModalRoute.withName('/home'));
    } else {
      print("Pilih metode");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _aksiFloatingButton();
          },
          child: Text("OK"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Text("Checkout"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                tglWktJemput(), //tanggal dan waktu jemput
                SizedBox(
                  height: 10.0,
                ),
                alamatJemput(), //alamat jemput
                Divider(),
                detailPesanan(),
                Divider(),
                kodePromo(),
                Divider(),
                rekap(),
                Divider(),
                metodeBayar()
              ],
            ),
          ),
        ));
  }

  Widget tglWktJemput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Tanggal Jemput',
              style: styleJudul,
            ),
            SizedBox(
              height: 3.0,
            ),
            Text('Minggu 11 Nov 2019')
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Waktu Jemput', style: styleJudul),
            SizedBox(
              height: 3.0,
            ),
            Text('Minggu 11 Nov 2019')
          ],
        )
      ],
    );
  }

  Widget alamatJemput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Alamat Jemput',
          style: styleJudul,
        ),
        SizedBox(
          height: 3.0,
        ),
        Text(
          'Jalan Pekapuran Raya Gang Ahmad Jamiri 2, Kecamatan Banjarmasin Timur 70234',
          textAlign: TextAlign.left,
        )
      ],
    );
  }

  Widget detailPesanan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Detail Pesanan',
          style: styleJudul,
        ),
        SizedBox(
          height: 3.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Re-Pair'),
                Text('2 Pasang'),
                Text('30.000')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Re-Sole'),
                Text('1 Pasang'),
                Text('90.000')
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('Transportasi'), Text('8.000')],
            )
          ],
        ),
      ],
    );
  }

  Widget kodePromo() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.scatter_plot,
          color: warnaPrimary,
        ),
        InkWell(onTap: () {}, child: Text('Kode Promo'))
      ],
    );
  }

  Widget rekap() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text('Total'), Text('128.000')],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text('Diskon'), Text('0')],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text('Grand Total'), Text('128.000')],
        ),
      ],
    );
  }

  Widget metodeBayar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Metode Pembayaran', style: styleJudul),
        SizedBox(
          height: 10.0,
        ),
        Container(
          color: Colors.grey[300],
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    groupValue: metodBayar,
                    onChanged: (value) {
                      _pilihMetodBayar(value);
                    },
                    value: "Saldo",
                    activeColor: warnaPrimary,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Saldo",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      Text("Bayar tagihan dengan saldo anda",
                          style: TextStyle(
                            fontSize: 10.0,
                          ))
                    ],
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: warnaPrimary,
                      child: Text(
                        "Saldo anda : Rp.50.000",
                        style: TextStyle(fontSize: 8.0, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    groupValue: metodBayar,
                    onChanged: (value) {
                      _pilihMetodBayar(value);
                    },
                    value: "COD",
                    activeColor: warnaPrimary,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Cash On Delivery (COD)",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      Text("Bayar tagihan langsung ditempat",
                          style: TextStyle(
                            fontSize: 10.0,
                          ))
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
