import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projek_ta/model/detailJasaModel.dart';
import 'package:projek_ta/model/ongkirModel.dart';
import 'package:projek_ta/views/pesan/checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class inputKetPesan extends StatefulWidget {
  final Map dataPilihanJasa; // ini berupa id aja contoh {1:0,2:0,3:0, dst}
  final List<OngkirModel> dataOngkir;
  final List<DetailJasaModel> dtDetailJasa;

  inputKetPesan(this.dataPilihanJasa, this.dataOngkir, this.dtDetailJasa);

  @override
  _inputKetPesanState createState() => _inputKetPesanState();
}

class _inputKetPesanState extends State<inputKetPesan> {
  String alamat, noHpPemesan, tglWaktuInput, cttnPesanan, idPlg;
  int _valuePilihKec;
  //data siap masuk ke api

  String tglJemputTampil = "Atur tanggal", wktJemputTampil = "Atur waktu";
  String tglJemputKonvert, wktJemputKonvert;

  Future<Null> _selectDate() async {
    final DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2020));
    if (_datePicker != null) {
      setState(() {
        tglJemputTampil = DateFormat('d MMM yyyy').format(_datePicker);
        tglJemputKonvert = "${DateFormat('yyyy-MM-dd').format(_datePicker)}";
      });
    }
  }

  Future<Null> _selectTime() async {
    final TimeOfDay _timePicker = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 00, minute: 00),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });
    if (_timePicker != null) {
      setState(() {
        wktJemputTampil = "${_timePicker.toString().substring(10, 15)} WITA";
        wktJemputKonvert = "${_timePicker.toString().substring(10, 15)}:00";
      });
    }
  }

  final _formState = GlobalKey<FormState>();
  final _scaffoldState = GlobalKey<ScaffoldState>();
  var _autovalidate = false;

  check() {
    final form = _formState.currentState;
    if (form.validate()) {
      form.save();
      if (tglJemputTampil != "Atur tanggal" &&
          wktJemputTampil != "Atur waktu" &&
          _valuePilihKec != null) {
        tglWaktuInput = "$tglJemputKonvert $wktJemputKonvert";
        gabungData();
        print(
            "$alamat $_valuePilihKec $tglWaktuInput $noHpPemesan $cttnPesanan");
        print(widget.dataPilihanJasa);
        print(dataSiapKirim);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Checkout(
                    dataSiapKirim, widget.dataOngkir, widget.dtDetailJasa)));
      } else {
        _snackBarShow("Input data jangan ada yang kosong");
      }
    } else {
      setState(() {
        print("gagal");
        _autovalidate = true;
      });
    }
  }

  Map dataSiapKirim; //model yang ini nah // {1: 1, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0, 13: 0, 14: 0, 15: 0, 16: 1, waktu_jemput: 2019-06-27 17:00:00, alamat_pesanan: asd, id_ongkir: 1, nohp_pemesan: 123, catatan_pesanan: asd, id_metode_bayar: null, id_plg: 29}
  gabungData() {
    setState(() {
      dataSiapKirim = widget.dataPilihanJasa;
      dataSiapKirim["waktu_jemput"] = tglWaktuInput;
      dataSiapKirim["alamat_pesanan"] = alamat;
      dataSiapKirim["id_ongkir"] = _valuePilihKec;
      dataSiapKirim["nohp_pemesan"] = noHpPemesan;
      dataSiapKirim["catatan_pesanan"] = cttnPesanan;
      dataSiapKirim["id_metode_bayar"] = null;
      dataSiapKirim["id_plg"] = idPlg;
    });
  }

  _snackBarShow(String str) {
    _scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(str),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
      ),
    ));
  }

  String _pilihKec = "Pilih kecamatan anda";
  // int _valuePilihKec; ada diatas
  List<PopupMenuItem> itemKecamatan = [];
  final GlobalKey _menuKey = GlobalKey();

  handlePopupChange(String value) {
    setState(() {
      _valuePilihKec = int.parse(value);
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idPlg = preferences.getString("idPlg");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();

    for (OngkirModel item in widget.dataOngkir) {
      itemKecamatan.add(PopupMenuItem(
        child: Text("${item.kecamatan}"),
        value: item.id_ongkir,
      ));
    }

    print(widget.dataPilihanJasa);
    print(widget.dataOngkir);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text("Input keterangan"),
      ),
      persistentFooterButtons: <Widget>[
        MaterialButton(
          onPressed: () => check(),
          minWidth: screenSize.width / 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Color.fromARGB(255, 116, 150, 213),
          child: Row(
            children: <Widget>[Text("Lanjutkan"), Icon(Icons.chevron_right)],
          ),
          textColor: Colors.white,
        )
      ],
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            height: screenSize.height / 5,
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.date_range,
                  size: 70.0,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  'Atur alamat dan waktu penjemputan',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0),
                )
              ],
            ),
          ),
          Form(
            key: _formState,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autovalidate: _autovalidate,
                    onSaved: (e) => alamat = e,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Isi alamat anda";
                      } else if (e.length < 30) {
                        return "Alamat terlalu pendek isikan alamat lengkap anda";
                      }
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Alamat Penjemputan",
                      hintText: "Masukkan alamat anda",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.add_location),
                    title: Text('Pilih Kecamatan'),
                    subtitle: _valuePilihKec == null
                        ? Text(_pilihKec)
                        : Text(
                            "${widget.dataOngkir[_valuePilihKec - 1].kecamatan}"),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.arrow_drop_down),
                      key: _menuKey,
                      onSelected: (value) =>
                          handlePopupChange(value.toString()),
                      itemBuilder: (BuildContext context) => itemKecamatan,
                      tooltip: "Pilih kecamatan",
                    ),
                    onTap: () {
                      dynamic popUpMenuState = _menuKey.currentState;
                      popUpMenuState.showButtonMenu();
                    },
                  ),
                  InkWell(
                    onTap: () => _selectDate(),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text("Tanggal Jemput"),
                      subtitle: Text(tglJemputTampil),
                    ),
                  ),
                  InkWell(
                    onTap: () => _selectTime(),
                    child: ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text("Waktu Jemput"),
                      subtitle: Text(wktJemputTampil),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: TextFormField(
                      autovalidate: _autovalidate,
                      keyboardType: TextInputType.phone,
                      onSaved: (e) => noHpPemesan = e,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Masukan no handphone anda";
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Masukan no hp yang bisa dihubungi",
                        hintStyle: TextStyle(fontSize: 12.0),
                        labelText: "No Handphone",
                      ),
                    ),
                    // subtitle: Text(wktJemputTampil),
                  ),
                  ListTile(
                    leading: Icon(Icons.collections_bookmark),
                    title: TextFormField(
                      onSaved: (e) => cttnPesanan = e,
                      decoration: InputDecoration(
                        hintText: "Catatan pesanan jika ada",
                        hintStyle: TextStyle(fontSize: 12.0),
                        labelText: "Catatan Pesanan",
                      ),
                    ),
                    // subtitle: Text(wktJemputTampil),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

// openDropdown() {
//   return DropdownButton(
//     items: kecamatan.map((String value) {
//       return DropdownMenuItem(
//         child: (Text(value)),
//         value: value,
//       );
//     }).toList(),
//     onChanged: (selected) {
//       setState(() {
//         _pilihKec = selected;
//         print(_pilihKec);
//       });
//     },
//     // value: _pilihKec,
//   );
// }
