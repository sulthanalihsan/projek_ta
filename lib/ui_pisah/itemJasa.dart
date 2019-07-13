import 'package:flutter/material.dart';

class ItemJasa extends StatefulWidget {
  String title, subtitle;
  ItemJasa({this.title, this.subtitle});
  @override
  _ItemJasaState createState() => _ItemJasaState();
}

class _ItemJasaState extends State<ItemJasa> {
  int _itemCount = 0;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 20.0),
      ),
      subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:0.0),
              child: Text(widget.subtitle,style: TextStyle(fontSize: 14.0)),
            ),
            Text("cth: sepatu flat, cewe, anak-anak",style: TextStyle(fontSize: 10.0),),
          ]),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _itemCount != 0
              ? IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red[200],
                    size: 28.0,
                  ),
                  onPressed: () => setState(() => _itemCount--),
                )
              : Container(),
          Text(
            _itemCount.toString(),
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
          ),
          IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).primaryColor,
                size: 28.0,
              ),
              onPressed: () => setState(() => _itemCount++))
        ],
      ),
    );
  }
}
