import 'package:flutter/material.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_hello_world/support.dart';
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

class _FriendList extends State<FriendList> with AccountPageDesigns {
  String searchedName = '', tappedName, tappedUid;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<List<OtherUsers>>(
        stream: DatabaseService(
                uid: user.uid,
                searchedName: searchedName,
                usrFullName: user.fullName)
            .friends,
        builder: (context, snap) {
          return Stack(
            children: <Widget>[
              Positioned.fill(
                  child: Container(
                color: bgColorBottom,
              )),
              placementWidget(
                width: 340,
                height: 50,
                top: 15,
                start: 18,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: bgColorTop),
                  child: TextField(
                      textAlign: TextAlign.justify,
                      enableSuggestions: true,
                      cursorColor: bgColorBottom,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: defaultFont),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: bgColorBottom,
                          ),
                          hintText: 'Search Friends'),
                      onChanged: (input) {
                        setState(() {
                          searchedName = input;
                        });
                      }),
                ),
              ),
              placementWidget(
                height: 520,
                width: 340,
                top: 104,
                start: 18,
                child: snap.hasData
                    ? ListView.builder(
                        itemCount: snap.data.length,
                        itemBuilder: (context, index) {
                          var listItem = snap.data.elementAt(index);
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: cardColorFriends,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ListTile(
                                dense: true,
                                onTap: () {
                                  setState(() {
                                    tappedName = listItem.fullName;
                                    tappedUid = listItem.uid;
                                  });
                                  friendsStreamController
                                      .add(tappedUid + ' ; ' + tappedName);
                                },
                                title: Text(
                                  listItem.fullName,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: defaultFont,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Username : ${listItem.userName}',
                                  style: TextStyle(
                                      color: bgColorBottom,
                                      fontFamily: defaultFont,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        })
                    : SpinKitChasingDots(color: Colors.black, size: 50),
              )
            ],
          );
        });
  }
}
