import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gif_search/UI/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchString;
  int _offset;
  String trendingURL;
  String searchURL;
  Map<String, dynamic> dataFromJson;
  TextEditingController inputController;

  Future<Map> _getGIFS() async {
    http.Response response;
    if (_searchString == null || inputController.text.toString() == "") {
      trendingURL =
          "https://api.giphy.com/v1/gifs/trending?api_key=rnTU9iVdd3ChegLQiMCMRpYU7DSzWnoS&limit=20&rating=G";
      response = await http.get(trendingURL);
    } else {
      trendingURL =
          "https://api.giphy.com/v1/gifs/trending?api_key=rnTU9iVdd3ChegLQiMCMRpYU7DSzWnoS&limit=20&rating=G";
      searchURL =
          "https://api.giphy.com/v1/gifs/search?api_key=rnTU9iVdd3ChegLQiMCMRpYU7DSzWnoS&q=$_searchString&limit=19&offset=$_offset&rating=G&lang=en";

      response = await http.get(searchURL);
    }
    print(response);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _offset = 0;
    inputController = new TextEditingController();
    dataFromJson = new Map();

    _getGIFS().then((value) {
      dataFromJson = value;
    });
  }

  int _getCountGifs(List list) {
    if (_searchString == null) {
      return list.length;
    } else {
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
                child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: snapshot.data["data"][index]["images"]
                        ["fixed_height"]["url"],
                fit:BoxFit.cover,height: 300.0),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return GifPage(snapshot.data["data"][index]);
                  }));
                },
                onLongPress: () {
                  Share.share(snapshot.data["data"][index]["images"]
                      ["fixed_height"]["url"]);
                });
          } else {
            return Container(
                child: GestureDetector(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add, color: Colors.white, size: 50.0),
                          Text("Load more",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0))
                        ]),
                    onTap: () {
                      setState(() {
                        _offset += 19;
                      });
                    }));
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
                  controller: inputController,
                  decoration: InputDecoration(
                      labelText: "Search GIF",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder()),
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                  textAlign: TextAlign.center,
                  onSubmitted: (value) {
                    setState(() {
                      _searchString = value;
                      _offset = 0;
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
