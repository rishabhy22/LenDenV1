import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_hello_world/support.dart';

//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AddFriends extends StatefulWidget {
  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> with AccountPageDesigns {
  String searchedName;
  bool chk;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<List<OtherUsers>>(
      stream: DatabaseService(uid: user.uid, searchedName: searchedName)
          .showFriendsToAdd,
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
                    borderRadius: BorderRadius.circular(30), color: bgColorTop),
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
                        var otherUsers = snap.data.elementAt(index);
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: bgColorTop,
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
                                                    otherUsers.fullName+' ?',
                                                style: TextStyle(
                                                    fontFamily: defaultFont)),
                                            actions: <Widget>[
                                              FlatButton(
                                                  onPressed: () async {
                                                    final FirebaseUser currUser =
                                                        await FirebaseAuth
                                                            .instance
                                                            .currentUser();
                                                    chk = await DatabaseService(
                                                            uid: user.uid,
                                                            usrFullName: currUser
                                                                .displayName)
                                                        .sendFriendRequest(
                                                            otherUsers.uid,
                                                            otherUsers
                                                                .fullName,otherUsers.userName);
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            child: Text(
                                                                'Friend Request Sent to ' +
                                                                    otherUsers
                                                                        .fullName,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        defaultFont,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20)),
                                                          );
                                                        });
                                                  },
                                                  child: Text('YES',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              defaultFont,
                                                          color:
                                                              bgColorBottom))),
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('NO',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              defaultFont,
                                                          color:
                                                              bgColorBottom)))
                                            ],
                                          )
                                        : Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Text(
                                                'User is already friend or awaiting conformation',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: defaultFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                          );
                                  });
                            },
                            title: Text(otherUsers.fullName,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: defaultFont,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text('Username : ${otherUsers.userName}',style: TextStyle(
                                fontFamily: defaultFont,
                                fontWeight: FontWeight.bold,color: bgColorBottom)),
                          ),
                        );
                      },
                    )
                  : Text(
                      'OOPS! Nothing Here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: bgColorTop,
                        fontFamily: defaultFont,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
