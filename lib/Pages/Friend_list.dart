import 'package:flutter/material.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hello_world/inter_PageStreams.dart';

class FriendList extends StatefulWidget {
  final String uid;
  final Function option;

  FriendList({this.uid, this.option});

  @override
  _FriendList createState() {
    return _FriendList();
  }
}

class _FriendList extends State<FriendList> {
  String searchedName = '', tappedName, tappedUid;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: FlatButton(
          child: Icon(Icons.arrow_back_ios),
          onPressed: () {
            streamController.add(0);
          },
        ),
        title: Text("Friends"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<List<OtherUsers>>(
          stream: DatabaseService(
                  uid: user.uid,
                  searchedName: searchedName,
                  usrFullName: user.fullName)
              .friends,
          builder: (context, snap) {
            return Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 10,
                        child: TextField(
                            enableSuggestions: true,
                            cursorColor: Colors.black,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 4)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 4)),
                                hintText: 'Search Friends'),
                            onChanged: (input) {
                              setState(() {
                                searchedName = input;
                              });
                            }),
                      ),
                      Flexible(
                          child: FloatingActionButton(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.person_add,
                          size: 20,
                        ),
                        onPressed: () {
                          streamController.add(5);
                        },
                      )),
                    ],
                  ),
                ),
                snap.hasData
                    ? Flexible(
                        flex: 3,
                        child: ListView.builder(
                            itemCount: snap.data.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        tappedName =
                                            snap.data.elementAt(index).fullName;
                                        tappedUid =
                                            snap.data.elementAt(index).uid;
                                      });
                                      friendsStreamController.add(tappedUid+' ; '+tappedName);
                                    },
                                    title: Text(
                                      snap.data.elementAt(index).fullName,
                                    )),
                              );
                            }))
                    : SpinKitChasingDots(color: Colors.black, size: 50)
              ],
            );
          }),
    ));
  }
}
