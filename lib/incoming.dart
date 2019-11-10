import 'package:flutter/material.dart';

class Len extends StatefulWidget
{
  @override
  LenState createState()
  {
    return LenState();
  }
}
class LenState extends State<Len>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Len"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}