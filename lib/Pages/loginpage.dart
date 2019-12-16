import 'package:email_validator/email_validator.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/loading.dart';
import 'package:flutter_hello_world/support.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class _LoginPage extends State<LoginPage> with LoginPageDesigns {
  String email, pwd, errorMsg;
  final usrLoginKey = GlobalKey<FormState>();
  final AuthService auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    return loading
        ? Loading(
            loadingColor: bgColorTop,
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                "Login Page",
                style: TextStyle(
                    fontWeight: FontWeight.w900, fontFamily: defaultFont),
              ),
              backgroundColor: Colors.black,
            ),
            body: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Container(
                  color: bgColorBottom,
                )),
                placementWidget(
                  width: 341,
                  height: 126,
                  start: 17,
                  top: 270,
                  child: Form(
                    key: usrLoginKey,
                    child: Stack(
                      children: <Widget>[
                        placementWidget(
                          width: 341,
                          height: 55,
                          start: 0,
                          top: 0,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(37),
                                color: bgColorTop),
                            child: TextFormField(
                                textAlign: TextAlign.center,
                                cursorColor: bgColorBottom,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: bgColorBottom,
                                    fontFamily: defaultFont),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email'),
                                onChanged: (input) {
                                  setState(() {
                                    email = input;
                                  });
                                }),
                          ),
                        ),
                        placementWidget(
                          width: 341,
                          height: 55,
                          start: 0,
                          top: 71,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(37),
                                color: bgColorTop),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                cursorColor: bgColorBottom,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: bgColorBottom),
                                decoration: InputDecoration(
                                    errorStyle:
                                        TextStyle(fontFamily: defaultFont),
                                    border: InputBorder.none,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                placementWidget(
                  height: 34,
                  width: 149,
                  start: 113,
                  top: 416,
                  child: RaisedButton(
                    color: bgColorTop,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          fontFamily: defaultFont),
                    ),
                    onPressed: () async {
                      if (email != null && EmailValidator.validate(email)) {
                        dynamic result;
                        if (usrLoginKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          result =
                              await auth.signInWithEmailAndPassword(email, pwd);
                        }

                        if (result == null) {
                          setState(() {
                            loading = false;
                            errorMsg = 'Login failed! No such User';
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(content: Text(errorMsg));
                              });
                        }
                      } else {
                        errorMsg = 'Invalid Email';
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(content: Text(errorMsg));
                            });
                      }
                    },
                  ),
                ),
                placementWidget(
                  height: 34,
                  width: 149,
                  start: 113,
                  top: 510,
                  child: RaisedButton(
                    splashColor: bgColorBottom,
                    color: Color.fromRGBO(234, 22, 70, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Text(
                      "New User ? Register Here",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: defaultFont,
                          fontWeight: FontWeight.w900,
                          color: bgColorTop,
                          fontSize: 14),
                    ),
                    onPressed: () {
                      widget.toggle();
                    },
                  ),
                ),
                placementWidget(
                    width: 376,
                    height: 260,
                    top: 0,
                    start: 0,
                    child: Column1()),
              ],
            ),
          );
  }
}
