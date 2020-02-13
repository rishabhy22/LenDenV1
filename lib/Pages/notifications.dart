import 'package:flutter/material.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_hello_world/inter_PageStreams.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Notifications extends StatefulWidget {
  final Function option;

  Notifications({this.option});

  @override
  NotificationsState createState() {
    return NotificationsState();
  }
}

class NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
          child: Icon(Icons.arrow_back_ios),
          onPressed: () {
            streamController.add(0);
          },
        ),
        title: Text("Notifications"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: DatabaseService(uid: user.uid, usrFullName: user.fullName)
            .showFriendRequest,
        builder: (context, snap) {
          return snap.hasData
              ? ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (context, index) {
                    var otherUsers = snap.data.elementAt(index);
                    return Card(
                      child: ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Do you want to add ' +
                                            otherUsers.fullName),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () async {
                                            await DatabaseService(
                                                    uid: user.uid,
                                                    usrFullName: user.fullName)
                                                .addFriends(otherUsers.uid,
                                                    otherUsers.fullName);
                                            Navigator.of(context).pop();
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    child: Text(
                                                        'Added  ' +
                                                            otherUsers.fullName+' as Friend'),
                                                  );
                                                });
                                          },
                                          child: Text('YES')),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('NO'))
                                    ],
                                  );
                                });
                          },
                          title: Text('Friend Request from '+
                            snap.data.elementAt(index).fullName,
                          )),
                    );
                  })
              : SpinKitChasingDots(color: Colors.black, size: 50);
        },
      ),
    );
  }
}
