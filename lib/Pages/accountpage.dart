import 'dart:ui' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/loading.dart';


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
  @override
  _AccountPage createState() => _AccountPage();
}



class _AccountPage extends State<AccountPage> {
  final AuthService auth=AuthService();
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton.icon(
              onPressed: ()async {
                setState(() {
                  loading=true;
                });
                await auth.signOut();
              },
              icon: Icon(Icons.exit_to_app),
              label: Text('Logout'))
        ],
        title: Text('Len-Den'),
        backgroundColor: Color.fromRGBO(230, 65, 64, 1),
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
                secColor: Colors.green,
                s: 'Friends',
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
                      onPressed: () {}),
                ),
              ]),
            )
          ]),
    );
  }
}
