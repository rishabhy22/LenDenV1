import 'package:flutter/material.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
      home: Wrapper(),
    ));
  }
}
