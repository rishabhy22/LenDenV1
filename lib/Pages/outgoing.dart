import 'package:flutter/material.dart';

class Den extends StatefulWidget
{
  @override
  DenState createState()
  {
    return DenState();
  }
}
class DenState extends State<Den>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Den"),
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