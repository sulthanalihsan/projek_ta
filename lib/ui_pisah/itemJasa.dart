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
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _itemCount != 0
              ? IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => setState(() => _itemCount--),
                )
              : Container(),
          Text(_itemCount.toString()),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() => _itemCount++))
        ],
      ),
    );
  }
}
