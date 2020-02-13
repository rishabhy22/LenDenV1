import 'package:flutter/material.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_hello_world/inter_PageStreams.dart';

//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AddFriends extends StatefulWidget {
  final String fromWhereCalled;

  AddFriends({this.fromWhereCalled});

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  String searchedName;
  bool chk;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
          child: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (widget.fromWhereCalled == 'AccountPage')
              streamController.add(0);
            else
              streamController.add(1);
          },
        ),
        title: Text("Search Friends"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<List<OtherUsers>>(
        stream: DatabaseService(uid: user.uid, searchedName: searchedName)
            .showFriendsToAdd,
        builder: (context, snap) {
          return Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: TextField(
                    enableSuggestions: true,
                    cursorColor: Colors.black,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide:
                                BorderSide(color: Colors.teal, width: 4)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                BorderSide(color: Colors.black, width: 4)),
                        hintText: 'Search Friends'),
                    onChanged: (input) {
                      setState(() {
                        searchedName = input;
                      });
                    }),
              ),
              snap.hasData
                  ? Flexible(
                      flex: 3,
                      child: ListView.builder(
                        itemCount: snap.data.length,
                        itemBuilder: (context, index) {
                          var otherUsers = snap.data.elementAt(index);
                          return Card(
                            child: ListTile(
                              onTap: () async {
                                chk = await DatabaseService(uid: user.uid)
                                    .isFriendOrNot(otherUsers.uid);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return chk
                                          ? AlertDialog(
                                              title: Text(
                                                  'Do you want to send Friend Request to ' +
                                                      otherUsers.fullName),
                                              actions: <Widget>[
                                                FlatButton(
                                                    onPressed: () async {
                                                      chk = await DatabaseService(
                                                              uid: user.uid,
                                                              usrFullName:
                                                                  user.fullName)
                                                          .sendFriendRequest(
                                                              otherUsers.uid,
                                                              otherUsers
                                                                  .fullName);
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              child: Text(
                                                                  'Friend Request Sent to ' +
                                                                      otherUsers
                                                                          .fullName),
                                                            );
                                                          });
                                                    },
                                                    child: Text('YES')),
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('NO'))
                                              ],
                                            )
                                          : Dialog(
                                              child: Text(
                                                  'User is already friend or awaiting conformation'),
                                            );
                                    });
                              },
                              title: Text(otherUsers.fullName),
                            ),
                          );
                        },
                      ),
                    )
                  : Text('OOPS! Nothing Here'),
            ],
          );
        },
      ),
    );
  }
}
