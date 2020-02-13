import 'package:flutter/material.dart';
import 'package:flutter_hello_world/Pages/FriendDetailsPage.dart';
import 'package:flutter_hello_world/Pages/Friend_list.dart';
import 'package:flutter_hello_world/inter_PageStreams.dart';

class FriendWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        initialData: '0',
        stream: FriendOpStream().friendOpStream,
        builder: (context, snap) {
          if (snap.hasError)
            return Text('Error: ${snap.error}');
          else if (snap.hasData) {
            if (snap.data == '0') {
              return FriendList();
            } else{
              List<String>f=snap.data.split(' ; ');
              return FriendDetails(
                friendUid: f[0],friendName: f[1],
              );}
          }
          return FriendList();
        });
  }
}
