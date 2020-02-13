import 'package:flutter/material.dart';
import 'package:flutter_hello_world/Pages/createaccount.dart';
import 'package:flutter_hello_world/Pages/loginpage.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool chkSignIn=true;
  void toggle()
  {
    setState(() {
      chkSignIn=!chkSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
   if(chkSignIn)
     return LoginPage(toggle : toggle);
   else
     return RegDet(toggle : toggle);
  }
}
