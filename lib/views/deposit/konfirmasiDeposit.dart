import 'package:flutter/material.dart';
import 'package:projek_ta/views/deposit/detailTagihan.dart';

class KonfirmasiDeposit extends StatefulWidget {
  @override
  _KonfirmasiDepositState createState() => _KonfirmasiDepositState();
}

class _KonfirmasiDepositState extends State<KonfirmasiDeposit> {
  final Color warnaPrimary = Color.fromARGB(255, 116, 150, 213);
  final TextStyle styleJudul = TextStyle(
      color: Color.fromARGB(255, 116, 150, 213), fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    _alertDialogShow() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: new Text("Apakah anda yakin?"),
              content: new Text("Deposit saldo \nNominal: Rp.  \nBank: "),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                new FlatButton(
                  child: new Text("Yakin"),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home/detailTagihan',
                        ModalRoute.withName(Navigator.defaultRouteName));
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(
                    //         builder: (context) => DetailTagihan()),
                    //     ModalRoute.withName('/home/deposit_view"'));

                    // Navigator.of(context)
                    //     .pushReplacementNamed('/home/detailTagihan');

                    // Navigator.pushNamedAndRemoveUntil(context, '/home/detailTagihan', ModalRoute.withName('/home/deposit_view'));
                    // Navigator.of(context).pushNamedAndRemoveUntil('', );
                    // Navigator.of(context)
                    //     .pushReplacementNamed('/home/konfirmasiDeposit');
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => KonfirmasiDeposit()));
                  },
                ),
              ],
            );
          });
    }

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: screenSize.width / 2.3,
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey,
                    child: Text(
                      "BATAL",
                      textAlign: TextAlign.center,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: screenSize.width / 2.3,
                  child: FloatingActionButton(
                    child: Text(
                      "KONFIRMASI",
                      textAlign: TextAlign.center,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    onPressed: () {
                      _alertDialogShow();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("Konfirmasi Deposit"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Tanggal Transaksi",
                    style: styleJudul,
                  ),
                  Text("22 Juni 2019")
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Nominal Deposit",
                    style: styleJudul,
                  ),
                  Text("Rp 200.000")
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Tujuan Rekening",
                    style: styleJudul,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Bank"),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text("Atas Nama"),
                          ),
                          Text("No. Rek")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(":"),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(":"),
                          ),
                          Text(":")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("Bank BCA"),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text("M. Sulthan Al Ihsan"),
                          ),
                          Text("2857291529273")
                        ],
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: <Widget>[
                  //     Text("Bank"),
                  //     Text(":"),
                  //     Text("Bank BCA")
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: <Widget>[
                  //     Text("Atas Nama"),
                  //     Text(":"),
                  //     Text("Muhammad Sulthan Al Ihsan")
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: <Widget>[
                  //     Text("No.Rek "),
                  //     Text(":"),
                  //     Text("29586381957")
                  //   ],
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
