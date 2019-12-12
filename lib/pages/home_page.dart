import 'dart:convert';

import 'package:flutter_web/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _searchText;
  List<Container> _results;
  String buildUrl(search) =>
      "https://en.wikipedia.org/w/api.php?action=opensearch&search=${search}&format=json&origin=*";

  void _setSearchText(update) {
    setState(() {
      _searchText = update;
    });
  }

  void _makeSearch(search) async {
    List<Container> results = [];
    List<String> names = [];
    List<String> descriptions = [];
    List<String> links = [];

    var res = await http.get(buildUrl(search));
    var response = json.decode(res.body);
    print(response);

    response[1].forEach((x) => names.add(x));
    response[2].forEach((x) => descriptions.add(x));
    response[3].forEach((x) => links.add(x));

    for (int i = 0; i < names.length; i++) {
      print(names[i]);
      //results.add(new SearchResult(names[i], descriptions[i], links[i]));
      if (names[i] != null) {
        results.add(Container(child: Text(names[i])));
      }
    }

    setState(() {
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wikipedia Viewer"),
      ),
      body: Center(
        child: Container(
            height: 400.0,
            width: 300.0,
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              // borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Column(
              children: <Widget>[
                Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Search Here", style: TextStyle(fontSize: 36.0)),
                    Text(_searchText != null ? _searchText : ''),
                    TextField(
                      onChanged: (update) => _setSearchText(update),
                      onTap: () => _makeSearch("Sword"),
                    ),
                    RaisedButton(child: Text("Search"))
                  ],
                ),
                Column(
                  children: _results != null ? _results : [],
                )
              ],
            )),
      ),
    );
  }
}
