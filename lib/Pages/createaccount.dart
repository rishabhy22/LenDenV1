import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/loading.dart';

class RegDet extends StatefulWidget {
  final Function toggle;

  RegDet({this.toggle});

  @override
  _RegDet createState() => _RegDet();
}

class _RegDet extends State<RegDet> {
  final usrKey = GlobalKey<FormState>();
  String firstName, lastName, email,usrName, pwd, confirmPwd, errorMsg;
  final AuthService auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Create an Account"),
              backgroundColor: Colors.teal,
            ),
            body: Stack(children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  'assets/Images/money-related-icons-bank-money-related-icons-over-gray-background-colorful-design-vector-illustration-112614526.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                child: Form(
                  key: usrKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 14,
                      ),
                      TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 4)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 4)),
                              hintText: 'First Name'),
                          onChanged: (input) {
                            setState(() {
                              firstName = input;
                            });
                          }),
                      SizedBox(
                        height: 14,
                      ),
                      TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 4)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 4)),
                              hintText: 'Last Name'),
                          onChanged: (input) {
                            setState(() {
                              lastName = input;
                            });
                          }),
                      SizedBox(
                        height: 14,
                      ),
                      TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 4)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 4)),
                              hintText: 'Email'),
                          onChanged: (input) {
                            setState(() {
                              email = input;
                            });
                          }),
                      SizedBox(
                        height: 14,
                      ),
                      TextFormField(
                          cursorColor: Colors.white,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 4)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 4)),
                              hintText: 'Username'),
                          onChanged: (input) {
                            setState(() {
                              usrName = input;
                            });
                          }),
                      SizedBox(
                        height: 14,
                      ),
                      TextFormField(
                        cursorColor: Colors.white,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide:
                                    BorderSide(color: Colors.teal, width: 4)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 4)),
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
                      TextFormField(
                        cursorColor: Colors.white,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide:
                                    BorderSide(color: Colors.teal, width: 4)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 4)),
                            hintText: 'Confirm Password'
                        ,errorStyle: TextStyle(color: Colors.black)),
                        obscureText: true,
                        validator: (value) {
                          if (value.length < 8)
                            return 'Password strength must be greater than 8 characters';
                          else if(value!=pwd)
                            return 'Password does not match';
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        splashColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text('Register',style: TextStyle(color: Colors.white),),
                        color: Colors.black,
                        onPressed: () async {
                          if(EmailValidator.validate(email)) {
                            if (usrKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                              await auth.registerWithEmailAndPassword(
                                  firstName, lastName, email, pwd, usrName);
                              if (result == null) {
                                setState(() {
                                  errorMsg = 'Invalid Details';
                                  loading = false;
                                });
                              }
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
                      Text("Already have an account?",style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                      RaisedButton(
                        color: Colors.black,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0)),
                        child: Text("Login here!",style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          widget.toggle();
                        },
                      )
                    ],
                  ),
                ),
              )
            ]),
          );
  }
}
