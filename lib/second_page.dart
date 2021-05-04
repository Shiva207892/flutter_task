import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<Author> _authors = List<Author>();

  Future<List<Author>> fetchAuthors() async {
    var url = 'https://picsum.photos/v2/list';
    var response = await http.get(url);

    var authors = List<Author>();

    if (response.statusCode == 200) {
      var authorsJson = json.decode(response.body);
      for (var authorJson in authorsJson) {
        authors.add(Author.fromJson(authorJson));
      }
    }

    return authors;
  }

  int crossAxisCountValue = 2;

  void _setCrossAxisCountValue(double value) {
    setState(() {
      crossAxisCountValue = value.toInt();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAuthors().then((value) {
      setState(() {
        _authors.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(68, 76, 140, 1),
        title: Text("Authors Grid"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            child: Row(
              children: <Widget>[
                Text("  CrossAxisCount $crossAxisCountValue"),
                new Slider(
                    activeColor: Color.fromRGBO(68, 76, 140, 1),
                    min: 1,
                    max: 3,
                    value: crossAxisCountValue.toDouble(),
                    onChanged: _setCrossAxisCountValue),
              ],
            ),
          ),
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  itemCount: _authors.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCountValue),
                  itemBuilder: (context, index) {
                    return Card(
                        child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: Image.network(
                              _authors[index].imageSrc,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            height: 65,
                            color: Color.fromRGBO(68, 76, 140, 1),
                            child: ListTile(
                              title: Text(
                                _authors[index].name,
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ));
                  },
                )),
          )
        ],
      ),
    );
  }
}

class Author {
  String imageSrc, name;

  Author({
    @required this.imageSrc,
    @required this.name,
  });

  Author.fromJson(Map<String, dynamic> json) {
    imageSrc = json['download_url'];
    name = json['author'];
  }
}
