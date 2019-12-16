
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/support.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with AccountPageDesigns{
  final controllerPwd=TextEditingController();
  final controllerConfPwd=TextEditingController();
  final validateKey = GlobalKey<FormState>();
  String email='',newPwd='',currPwd='',confPwd='';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 30,),
        Flexible(
          flex: 3,
          child: Form(key: validateKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                cursorColor: Colors.white,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black,fontFamily: defaultFont),
                decoration: InputDecoration(hintText: 'Enter the Current Email'),
                onChanged: (input){
                  setState(() {
                    email = input;
                  });
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                cursorColor: Colors.white,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black,fontFamily: defaultFont),
                decoration: InputDecoration(hintText: 'Enter the Current Password'),
                onChanged: (input) {
                  setState(() {
                    currPwd = input;
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
              SizedBox(height: 20,),
              TextFormField(controller: controllerPwd,
                cursorColor: Colors.white,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black,fontFamily: defaultFont),
                decoration: InputDecoration(hintText: 'Enter the New Password'),
                onChanged: (input){
                  setState(() {
                    newPwd = input;
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
              SizedBox(height: 20,),
              TextFormField(controller: controllerConfPwd,
                cursorColor: Colors.white,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black,fontFamily: defaultFont),
                decoration: InputDecoration(hintText: 'Confirm Password'),
                onChanged: (input){
                  setState(() {
                    confPwd = input;
                  });
                },
                obscureText: true,
                validator: (value) {
                  if (confPwd!=newPwd)
                    return 'Password does not match. Enter Again';
                  else
                    return null;
                },
              ),
            ],
          ),
          ),
        ),
        Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
clipBehavior: Clip.antiAlias,
              child: RaisedButton(
                color: Colors.black,
          child: Text('Change Password',style: TextStyle(color: Colors.white,fontFamily: defaultFont),),
              onPressed: ()async{
              var chk=await AuthService().signInWithEmailAndPassword(email,currPwd);
              if(validateKey.currentState.validate()&&chk!=null)
                {
                  await AuthService().changePassword(newPwd);
                  controllerPwd.clear();
                  controllerConfPwd.clear();
                  newPwd=null;
                  showDialog(context: context,builder: (context){
                    return Dialog(
                      backgroundColor: bgColorBottom,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              15)),
                      child: Text('Password has been Changed', style: TextStyle(
                        fontSize: 18,
                        fontFamily: defaultFont,
                        color: bgColorTop,
                        fontWeight: FontWeight.bold)),);
                  });
                }
              else
                {
                  showDialog(context: context,builder: (context){
                    return Dialog(
                      backgroundColor: bgColorBottom,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              15)),
                      child: Text('Entered Email or Password doesn\'t match Current Password or Email', style: TextStyle(
                        fontSize: 18,
                          fontFamily: defaultFont,
                          color: bgColorTop,
                          fontWeight: FontWeight.bold)),);
                  });
                }
              }),
            ))
      ],
    );
  }
}
