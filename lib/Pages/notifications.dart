import 'package:flutter/material.dart';

class Notifications extends StatefulWidget
{
  @override
  NotificationsState createState()
  {
    return NotificationsState();
  }
}
class NotificationsState extends State<Notifications>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
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