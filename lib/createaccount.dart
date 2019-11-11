import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hello_world/accountpage.dart';

class RegDet extends StatefulWidget {
  RegDet({Key newUser}) : super(key: newUser);

  @override
  _RegDetState createState() => _RegDetState();
}

class _RegDetState extends State<RegDet> {
  final GlobalKey<FormState> usrKey = GlobalKey<FormState>();
  final firstName = TextEditingController(),
      lastName = TextEditingController(),
      email = TextEditingController(),
      pwd = TextEditingController(),
      confirmPwd = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: usrKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'First Name'),
              controller: firstName,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Last Name'),
              controller: lastName,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: email,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              controller: pwd,
              obscureText: true,
              validator: (value) {
                if (value.length < 8)
                  return 'Password strength must be greater than 8 characters';
                else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirm Password'),
              controller: confirmPwd,
              obscureText: true,
              validator: (value) {
                if (value.length < 8)
                  return 'Password strength must be greater than 8 characters';
                else
                  return null;
              },
            ),
            RaisedButton(
              child: Text('Register'),
              color: Colors.red,
              onPressed: () {
                if (usrKey.currentState.validate()) {
                  if (pwd.text == confirmPwd.text) {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email.text, password: pwd.text)
                        .then((currentUser) {
                      return Firestore.instance
                          .collection("AppUsers")
                          .document(currentUser.user.uid)
                          .setData({
                        "uid": currentUser.user.uid,
                        "fname": firstName.text,
                        "surname": lastName.text,
                        "email": email.text
                      }).then((result) {
                        firstName.clear();
                        lastName.clear();
                        email.clear();
                        pwd.clear();
                        confirmPwd.clear();
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return AccountPage(
                            user: currentUser.user,
                          );
                        }), (_) {
                          return false;
                        });
                      }).catchError((err) {
                        return print(err);
                      });
                    }).catchError((err) {
                      return print(err);
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("The passwords do not match"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  }
                }
              },
            ),
            Text("Already have an account?"),
            FlatButton(
              child: Text("Login here!"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  SignInState createState() {
    return SignInState();
  }
}

class SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create an Account"),
        backgroundColor: Colors.red,
      ),
      body: Stack(children: <Widget>[
        Center(
          child: Image.asset(
            'assets/Images/Money-in-Fascism-GQ-2018-103018.jpg',
            fit: BoxFit.cover,
          ),
        ),
        RegDet()
      ]),
    );
  }
}
