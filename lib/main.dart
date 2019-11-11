import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/accountpage.dart';
import 'package:flutter_hello_world/createaccount.dart';
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
  final email = TextEditingController();
  final pwd = TextEditingController();
  final GlobalKey<FormState> usrLoginKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

/*  @override
  void dispose() {
    usrName.dispose();
    pssWrd.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: ListView(
        children: <Widget>[
          Column1(),
          Text('Username'),
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter Your Email Here'),
            controller: email,
            keyboardType: TextInputType.emailAddress,
          ),
          Text('Password'),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Enter Your Password'),
            controller: pwd,
            validator: (value) {
              if (value.length < 8)
                return 'Password strength must be greater than 8 characters';
              else
                return null;
            },
          ),
          RaisedButton(
            color: Colors.red,
            onPressed: () async {
              if (usrLoginKey.currentState.validate()) {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email.text, password: pwd.text)
                    .then((currentUser) {
                  return Firestore.instance
                      .collection("AppUsers")
                      .document(currentUser.user.uid)
                      .get()
                      .then((result) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return AccountPage(
                        user: result["fname"],
                      );
                    }));
                  }).catchError((err) {
                    return print(err);
                  });
                }).catchError((err) {
                  return print(err);
                });
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('Invalid Username or Password'),
                      );
                    });
              }
            },
            child: Text('Login'),
          ),
          RaisedButton(
            color: Colors.red,
            child: Text('New User? Create an Account'),
            onPressed: () {
              Navigator.pushNamed(context, 'createaccount');
            },
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

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: (snapshot.hasData) ? 'accountpage' : 'loginpage',
            routes: {
              'loginpage': (context) {
                return SafeArea(child: LoginScaffold());
              },
              'createaccount': (context) {
                return SafeArea(child: SignIn());
              },
              'accountpage': (context) {
                return SafeArea(
                    child: AccountPage(
                  user: snapshot.data,
                ));
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
        });
  }
}
