import 'package:flutter/material.dart';
import 'package:share/share.dart';
class GifPage extends StatelessWidget {


  final Map<String,dynamic> _gifData;

  GifPage(this._gifData);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,title: Text(_gifData["title"]), centerTitle: true,actions: <Widget>[
        IconButton(icon: Icon(Icons.share), onPressed: (){
          Share.share(_gifData["images"]["fixed_height"]["url"]);
        })
      ]),
      backgroundColor: Colors.blueGrey,
      body: Center(child: Image.network(_gifData["images"]["fixed_height"]["url"]))
    );
  }
}
