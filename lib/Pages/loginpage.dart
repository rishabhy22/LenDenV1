import 'package:email_validator/email_validator.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/loading.dart';

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
          height: 215,
          width: 1000,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final Function toggle;

  LoginPage({this.toggle});

  @override
  _LoginPage createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  String email, pwd, errorMsg;
  final usrLoginKey = GlobalKey<FormState>();
  final AuthService auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text("Login Page"),
              backgroundColor: Colors.red,
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  // constraints: ,
                  color: Colors.teal,
                  child: Form(
                    key: usrLoginKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 4)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 4)),
                              hintText: 'Email'),
                          onChanged: (input) {
                            setState(() {
                              email = input;
                            });
                          },
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 4)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 4)),
                              hintText: 'Password'),
                          onChanged: (input) {
                            setState(() {
                              pwd = input;
                            });
                          },
                          obscureText: true,
                          validator: (value) {
                            if (value.length < 8)
                              return 'Password strength must be greater than 8 characters';
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          onPressed: () async {
                            if (EmailValidator.validate(email)) {
                              if (usrLoginKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                              }
                              dynamic result = await auth
                                  .signInWithEmailAndPassword(email, pwd);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  errorMsg = 'Login failed! No such User';
                                });
                              }
                            }
                            else
                            {
                              errorMsg='Invalid Email';
                              showDialog(context: context,builder: (BuildContext context){
                                return AlertDialog(content: Text(errorMsg));
                              });
                            }

                          },
                        ),
                        RaisedButton(
                          splashColor: Colors.green,
                          color: Colors.lightGreen,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text(
                            "New User ? Register Here",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          onPressed: () {
                            widget.toggle();
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Column1(),
              ],
            ),
          );
  }
}
