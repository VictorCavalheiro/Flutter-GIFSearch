import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static String _searchString;
  static int _offset = 0;
  static String trendingURL =
      "https://api.giphy.com/v1/gifs/trending?api_key=rnTU9iVdd3ChegLQiMCMRpYU7DSzWnoS&limit=20&rating=G";
  static String searchURL =
      "https://api.giphy.com/v1/gifs/search?api_key=rnTU9iVdd3ChegLQiMCMRpYU7DSzWnoS&q=$_searchString&limit=19&offset=$_offset&rating=G&lang=en";

  Map<String, dynamic> dataFromJson = new Map();


  Future<Map> _getGIFS() async {
    http.Response response;
    if (_searchString == null) {
      response = await http.get(trendingURL);
    } else {
      response = await http.get(searchURL);
    }
    print(response);
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getGIFS().then((value) {
      dataFromJson = value;
    });
  }

  int _getCountGifs(List list) {
    if (_searchString == null) {
      return list.length;
    }
    else {
      return list.length + 1;
    }
  }

  Widget _createGifTable(context, snapshot) {

    return GridView.builder(
        padding: EdgeInsets.all(5.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
        itemCount: _getCountGifs(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_searchString == null || index < snapshot.data["data"].length) {
            return GestureDetector(

                child: Image.network(
                    snapshot
                        .data["data"][index]["images"]["fixed_height"]["url"],
                    height: 300.0,
                    fit: BoxFit.cover),
                );
          } else {
            return Container(child: GestureDetector(child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 50.0),
                  Text("Load more",style: TextStyle(color: Colors.white,fontSize: 20.0))
                ]),onTap: (){setState(() {
                  _offset+=19;
                });}));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Image.network(
                "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif")),
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                  decoration: InputDecoration(
                      labelText: "Search GIF",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder()),
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                  textAlign: TextAlign.center,
                  onSubmitted: (value) {
                    setState(() {
                      _searchString = value;
                    });
                  })),
          Expanded(
              child: FutureBuilder(
                  future: _getGIFS(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case (ConnectionState.none):
                      case (ConnectionState.waiting):
                        return Container(
                            height: 200.0,
                            width: 200.0,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 4.0,
                            ));

                      default:
                        if (snapshot.hasError) {
                          return Container(
                              child: Text("Erro encontrado",
                                  style: TextStyle(color: Colors.white)));
                        } else {
                          return _createGifTable(context, snapshot);
                        }
                    }
                  }))
        ]));
  }
}
