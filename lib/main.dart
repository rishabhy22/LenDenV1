import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}

class RandomWords extends StatefulWidget {
  final Color color;

  RandomWords({this.color});

  @override
  RandomWordsState createState() {
    return RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return RaisedButton(
      color: widget.color,
      splashColor: Colors.teal,
      child: Container(
        child: Align(
          child: Text(
            wordPair.asPascalCase,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black38),
          ),
          alignment: Alignment.center,
        ),
      ),
      onPressed: () {
        setState(() {});
      },
    );
  }

  RandomWordsState();
}

class Column1 extends StatelessWidget {
  final Color color;

  Column1({this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Image.asset(
        'assets/Images/crop.jpg',
        height: 300,
        width: 1000,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        colorBlendMode: prefix0.BlendMode.hardLight,
      ),
      alignment: Alignment.topCenter,
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

void main() {
  return runApp(MyApp());
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Owl App'),
          backgroundColor: Colors.red,
        ),
        body: Column(
            //    mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Stack(
                  children: <Widget>[
                    Column1(
                      color: Colors.orange,
                    ),
                    Align(
                      child: FloatingActionButton(
                        splashColor: Colors.black,
                        child: Icon(
                          Icons.settings,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      alignment: Alignment(0.85, 0.8),
                    )
                  ],
                ),
              ),
              Expanded(
                child: RandomWords(
                  color: Colors.orange,
                ),
              ),
              Expanded(
                child: RandomWords(
                  color: Colors.deepPurple,
                ),
              ),
              Expanded(
                child: Stack(children: <Widget>[
                  Positioned.fill(
                    child: RandomWords(
                      color: Colors.green,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                        splashColor: Colors.black,
                        child: Icon(
                          Icons.ac_unit,
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {});
                        }),
                  ),
                ]),
              )
            ]),
      ),
    );
  }
}
