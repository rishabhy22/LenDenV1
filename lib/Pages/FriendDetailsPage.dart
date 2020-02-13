import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_hello_world/inter_PageStreams.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hello_world/authentication.dart';

class FriendDetails extends StatefulWidget {
  final String friendUid, friendName;

  FriendDetails({this.friendUid, this.friendName});

  @override
  _FriendDetailsState createState() => _FriendDetailsState();
}

class _FriendDetailsState extends State<FriendDetails> {
  var txtController = TextEditingController();
  int lenOrDen;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
          child: Icon(Icons.arrow_back_ios),
          onPressed: () {
            friendsStreamController.add('0');
          },
        ),
        title: Text(widget.friendName),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: StreamBuilder<DocumentSnapshot>(
            stream: DatabaseService(
                    tappedFriendUid: widget.friendUid, uid: user.uid)
                .bringRecordsOfFriends,
            builder: (context, doc) {
              var friendRecord = FriendRecordModel();
              return Column(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                        controller: txtController,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(
                                    color: Colors.black38, width: 4)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 4)),
                            hintText: 'Enter Len or Den Value'),
                        onChanged: (input) {
                          setState(() {
                            lenOrDen = int.parse(input).abs();
                          });
                        }),
                  ),
                  Flexible(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                txtController.clear();
                              },
                              child: Text('Add Len')),
                        ),
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                txtController.clear();
                              },
                              child: Text('Add Den')),
                        )
                      ],
                    ),
                  ),
                  doc.hasData
                      ? Text(doc.data['whoSentName'] ?? '')
                      : SpinKitChasingDots(color: Colors.black, size: 50)
                ],
              );
            }),
      ),
    );
  }
}
