import 'package:flutter/material.dart';
import 'package:flutter_hello_world/Pages/search_friends.dart';
import 'package:flutter_hello_world/authenticate.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/inter_PageStreams.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hello_world/FriendWrapper.dart';
import 'package:flutter_hello_world/Pages/accountpage.dart';
import 'package:flutter_hello_world/Pages/expenses.dart';
import 'package:flutter_hello_world/Pages/notifications.dart';
import 'inter_PageStreams.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user != null) {
      streamController.add(0);
      print(user.uid);
      print(user.fullName);
    } else
      streamController.add(-1);
    return StreamBuilder<int>(
      stream: OpStream().opStream,
      initialData: 0,
      builder: (context, snap) {
        if (snap.hasError)
          return Text('Error: ${snap.error}');
        else if (snap.hasData) {
          switch (snap.data) {
            case 0:
              return AccountPage();
            case 1:
              return FriendWrapper();
            case 2:
              return Expenses();
            case 3:
              return Notifications();
            case 4:
              return AddFriends(
                fromWhereCalled: 'AccountPage',
              );
            case 5:
              return AddFriends(
                fromWhereCalled: 'Friends',
              );
            case -1:
              return Authenticate();
          }
        }
        return AccountPage();
      },
    );
  }
}
