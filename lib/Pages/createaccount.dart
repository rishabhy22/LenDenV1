import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_hello_world/loading.dart';
import 'package:flutter_hello_world/support.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegDet extends StatefulWidget {
  final Function toggle;

  RegDet({this.toggle});

  @override
  _RegDet createState() => _RegDet();
}

class _RegDet extends State<RegDet> with LoginPageDesigns {
  final usrKey = GlobalKey<FormState>();
  String firstName, lastName, email, usrName, pwd, confirmPwd, errorMsg;
  final AuthService auth = AuthService();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    return loading
        ? Loading(loadingColor: bgColorTop,)
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Create an Account",style: TextStyle(fontWeight: FontWeight.w900,fontFamily: defaultFont),),
              backgroundColor: bgColorBottom,
            ),
            body: Stack(children: <Widget>[
              Positioned.fill(
                  child: Container(
                color: bgColorBottom,
              )),
              placementWidget(
                top: 18,
                start: 17,
                width: 341,
                height: 410,
                child: Form(
                  key: usrKey,
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
                                  hintText: 'First Name'),
                              onChanged: (input) {
                                setState(() {
                                  firstName = input;
                                });
                              }),
                        ),
                      ),
                      placementWidget(
                        width: 341,
                        height: 55,
                        start: 0,
                        top: 71,
                        child: Container(alignment: Alignment.center,
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
                                  hintText: 'Last Name'),
                              onChanged: (input) {
                                setState(() {
                                  lastName = input;
                                });
                              }),
                        ),
                      ),
                      placementWidget(
                        width: 341,
                        height: 55,
                        start: 0,
                        top: 142,
                        child: Container(alignment: Alignment.center,
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
                                  border: InputBorder.none, hintText: 'Email'),
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
                          top: 213,
                          child: Container(alignment: Alignment.center,
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
                                    hintText: 'Username'),
                                onChanged: (input) {
                                  setState(() {
                                    usrName = input;
                                  });
                                }),
                          )),
                      placementWidget(
                        width: 341,
                        height: 55,
                        start: 0,
                        top: 284,
                        child: Container(alignment: Alignment.center,
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
                                  border: InputBorder.none, hintText: 'Password'),
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
                      placementWidget(
                        width: 341,
                        height: 55,
                        start: 0,
                        top: 355,
                        child: Container(alignment: Alignment.center,
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
                                  border: InputBorder.none,
                                  hintText: 'Confirm Password',
                                 ),
                              obscureText: true,
                              validator: (value) {
                                if (value.length < 8)
                                  return 'Password strength must be greater than 8 characters';
                                else if (value != pwd)
                                  return 'Password does not match';
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
                top: 466,
                start: 113,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Text(
                    'Register',
                    style: TextStyle(color: bgColorBottom,fontFamily: defaultFont,fontWeight: FontWeight.w900),
                  ),
                  color: bgColorTop,
                  onPressed: () async {
                    if (usrName!=null&&await DatabaseService().isUserNameAvailable(usrName)) {
                      if (email!=null&&EmailValidator.validate(email)) {
                        dynamic result;
                        if (usrKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          result =
                          await auth.registerWithEmailAndPassword(
                              firstName, lastName, email, pwd, usrName);
                        }
                          if (result == null) {
                            setState(() {
                              errorMsg = 'Invalid Details. Registeration Failed';
                              loading = false;
                            });

                            showDialog(context: context, builder: (BuildContext context) {
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
                    }
                    else
                      {
                        
                        if (email!=null) {
                          errorMsg = 'Username not Available';
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(content: Text(errorMsg));
                              });
                        }
                      }
                  },
                ),
              ),
              placementWidget(
                start: 17,
                top: 544,
                width: 341,
                height: 30,
                child: Text(
                  "Already have an account?",
                  style: TextStyle(fontWeight: FontWeight.w900,fontFamily: defaultFont,color: bgColorTop),
                  textAlign: TextAlign.center,
                ),
              ),
              placementWidget(
                width: 149,
                height: 34,
                start: 113,
                top: 574,
                child: RaisedButton(
                  color: bgColorTop,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Text(
                    "Login here!",
                    style: TextStyle(color: bgColorBottom,fontFamily: defaultFont,fontWeight: FontWeight.w900),
                  ),
                  onPressed: () {
                    widget.toggle();
                  },
                ),
              )
            ]),
          );
  }
}
