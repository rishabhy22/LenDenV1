import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hello_world/accountpage.dart';
import 'package:flutter_hello_world/incoming.dart';
import 'package:flutter_hello_world/notifications.dart';
import 'package:flutter_hello_world/outgoing.dart';

void main() {
  return runApp(LoginPage());
}

class LoginClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(size.width, size.height * 0.5);
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

class Column1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipBehavior: Clip.antiAlias,
      clipper: LoginClipper(),
      child: Container(
        child: Image.asset(
          'assets/Images/Abstract-minimalist-wallpaper-HD-desktop-download.png',
          height: 250,
          width: 1000,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}

class UsrChk extends StatefulWidget {
  @override
  _UsrChkState createState() {
    return _UsrChkState();
  }
}

class _UsrChkState extends State<UsrChk> {
  final usrName = TextEditingController();
  final pssWrd = TextEditingController();
  @override
  void initState()
  {
    super.initState();
    usrName.addListener((){});
    pssWrd.addListener((){});
  }
  @override
  void dispose()
  {
    usrName.dispose();
    pssWrd.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: ListView(
        children: <Widget>[
          Column1(),
          Text('Username'),
          TextField(
            decoration: InputDecoration(labelText: 'Enter Your Username Here'),
            controller: usrName,
          ),
          Text('Password'),
          TextField(
            decoration: InputDecoration(labelText: 'Enter Your Password'),
            controller: pssWrd,
          ),
          RaisedButton(
            color: Colors.red,
            onPressed: () {
              if(usrName.text=='Rishabh Yadav'&&pssWrd.text=='abcd')
                return Navigator.pushNamed(context, 'accountpage');
              else
                return showDialog(context: context,
                builder: (context){
                  return AlertDialog(
                    content: Text('Invalid Username or Password'),
                  );
                }
                );
            },
            child: Container(child: Text('Login')),
          )
        ],
      ),
    );
  }
}

class LoginScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          UsrChk(),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'loginpage',
      routes: {
        'loginpage': (context) {
          return SafeArea(child: LoginScaffold());
        },
        'accountpage': (context) {
          return SafeArea(child: AccountPage());
        },
        'incoming': (context) {
          return SafeArea(child: Len());
        },
        'outgoing': (context) {
          return SafeArea(child: Den());
        },
        'notifications': (context) {
          return SafeArea(child: Notifications());
        }
      },
    );
  }
}
