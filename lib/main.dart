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
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            child: Align(child: Text(wordPair.asPascalCase),alignment: Alignment.topCenter,),
            color: widget.color,
          ),
        ),
        Align(
          child: RaisedButton(
              child: Icon(Icons.ac_unit, color: widget.color),
              onPressed: () {
                setState(() {});
              }),
          alignment: Alignment.bottomRight,
        )
      ],
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

void main() => runApp(MyApp());

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    return MaterialApp(
      title: 'My App',
      color: Color(0xffd3e322),
      home: Scaffold(
        appBar: AppBar(
          title: Text('App'),
          backgroundColor: Colors.red,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 3,
                child: RandomWords(
                  color: Colors.orange,
                ),
              ),
              Flexible(
                child: RandomWords(
                  color: Colors.blue,
                ),
              ),
              Flexible(
                child: RandomWords(
                  color: Colors.green,
                ),
              ),
              Flexible(
                  flex: 2,
                  child: RandomWords(
                    color: Colors.deepPurple,
                  ))
            ]),
        bottomNavigationBar: FloatingActionButton(
          child: Icon(
            Icons.view_headline,
            color: Color(0xffd3e322),
            size: 30,
          ),
          onPressed: () {
            setState(() {});
          },
        ),
      ),
    );
  }
}
