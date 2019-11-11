import 'dart:ui' as prefix0;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:provider/provider.dart';

class MyClipper extends CustomClipper<Path> {
  bool b = false;

  MyClipper({this.b});

  @override
  Path getClip(Size size) {
    Path path = Path();
    if (b) path.lineTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.5, size.height);
    if (b) path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class Options extends StatefulWidget {
  final Color color, secColor;
  final String s;
  final int opNo;

  Options({this.color, this.secColor, this.s, this.opNo});

  @override
  OptionsState createState() {
    return OptionsState();
  }
}

class OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.secColor,
      child: ClipPath(
        clipBehavior: Clip.antiAlias,
        clipper: MyClipper(b: false),
        child: RaisedButton(
          color: widget.color,
          splashColor: Colors.teal,
          child: Container(
            child: Text(
              widget.s,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.black38),
            ),
            alignment: Alignment.center,
          ),
          onPressed: () {
            if (widget.opNo == 1)
              Navigator.pushNamed(
                context,
                'incoming',
              );
            if (widget.opNo == 2)
              Navigator.pushNamed(
                context,
                'outgoing',
              );
            if (widget.opNo == 3) Navigator.pushNamed(context, 'notifications');
            setState(() {});
          },
        ),
      ),
    );
  }
}

class Column1 extends StatelessWidget {
  final Color color;

  Column1({this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.color,
      child: ClipPath(
        clipBehavior: Clip.antiAlias,
        clipper: MyClipper(b: true),
        child: Image.asset(
          'assets/Images/pexels-photo-751373.jpeg',
          height: 300,
          width: 1000,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          colorBlendMode: prefix0.BlendMode.hardLight,
        ),
      ),
      alignment: Alignment.topCenter,
    );
  }
}

class Top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DropdownButton<String>(
          underline: Container(),
          icon: CircleAvatar(
            maxRadius: 30,
            child: Icon(
              Icons.settings,
              size: 30,
            ),
          ),
          items: <String>['Add Friends', 'Settings'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}

class AccountPage extends StatefulWidget {
  AccountPage({Key key, this.user}):super(key:key);
  FirebaseUser user;
  @override
  AccountPageState createState() {
    return AccountPageState();
  }
}

class AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owl App'),
        backgroundColor: Color.fromRGBO(230, 65, 64, 1),
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
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
                    child: Top(),
                    alignment: Alignment(0.85, 0.8),
                  )
                ],
              ),
            ),
            Expanded(
              child: Options(
                opNo: 1,
                color: Colors.orange,
                secColor: Colors.deepPurple,
                s: 'Len',
              ),
            ),
            Expanded(
              child: Options(
                opNo: 2,
                s: 'Den',
                color: Colors.deepPurple,
                secColor: Colors.green,
              ),
            ),
            Expanded(
              child: Stack(children: <Widget>[
                Positioned.fill(
                  child: Options(
                    opNo: 3,
                    s: 'Notifications',
                    color: Colors.green,
                    secColor: Colors.green,
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
                      }),
                ),
              ]),
            )
          ]),
    );
  }
}
