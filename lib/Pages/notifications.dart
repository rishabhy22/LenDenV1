import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_hello_world/loading.dart';
import 'package:flutter_hello_world/support.dart';
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

class NotificationsState extends State<Notifications> with AccountPageDesigns {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<Iterable<Query>>(
        stream: DatabaseService(uid: user.uid).showLenDenRequest,
        builder: (context, snapLD) {
          List<NotificationModel> notifications = List<NotificationModel>();
          if (snapLD.hasData) {
            snapLD.data.forEach((docs) {
              docs.snapshots().forEach((doc) {
                notifications.addAll(doc.documents.map((doc) {
                  return NotificationModel(
                      friendshipUid: doc.data['friendshipUid'] ?? '',
                      docUid: doc.data['docUid'] ?? '',
                      uid: doc.data['whoSentUid'] ?? '',
                      fullName: doc.data['whoSentName'] ?? '',
                      proposedLen: doc.data['len'],
                      proposedDen: doc.data['den']);
                }));
              });
            });
          }
          return StreamBuilder<Iterable<Query>>(
            stream: DatabaseService(uid: user.uid).showPayments,
            builder: (context, snapP) {
              List<NotificationModel> notificationsPayments =
                  List<NotificationModel>();
              if (snapP.hasData) {
                snapP.data.forEach((docs) {
                  docs.snapshots().forEach((doc) {
                    notificationsPayments.addAll(doc.documents.map((doc) {
                      return NotificationModel(
                          friendshipUid: doc.data['friendshipUid'] ?? '',
                          docUid: doc.data['docUid'] ?? '',
                          uid: doc.data['whoPaidUid'] ?? '',
                          fullName: doc.data['whoPaidName'] ?? '',
                          payment: doc.data['value']);
                    }));
                  });
                });
              }
              return StreamBuilder<List<NotificationModel>>(
                stream:
                    DatabaseService(uid: user.uid, usrFullName: user.fullName)
                        .showFriendRequest,
                builder: (context, snapFR) {
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                          child: Container(
                        color: bgColorBottom,
                      )),
                      placementWidget(
                        start: 22,
                        top: 30,
                        width: 286,
                        height: 198,
                        child: Container(
                          child: Text('LenDen Notifications',textAlign: TextAlign.center,style: TextStyle(fontFamily: defaultFont)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(38),
                              color: bgColorTop),
                        ),
                      ),
                      placementWidget(
                        start: 67,
                        top: 224,
                        width: 286,
                        height: 198,
                        child: Container(
                          child: Text('Payment Notifications',textAlign: TextAlign.center,style: TextStyle(fontFamily: defaultFont)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(38),
                              color: bgColorTop),
                        ),
                      ),
                      placementWidget(
                          start: 22,
                          top: 420,
                          height: 198,
                          width: 286,
                          child: Container(
                            child: Text('Friend Requests',textAlign: TextAlign.center,style: TextStyle(fontFamily: defaultFont),),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38),
                                  color: bgColorTop))),
                      placementWidget(
                        start: 29,
                        top: 72,
                        width: 273,
                        height: 136,
                        child: snapLD.hasData
                            ? ListView.builder(
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  var listItem = notifications.elementAt(index);
                                  return (listItem.uid != user.uid)
                                      ? Card(
                                    color: cardColor,
                                    shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                          child: ListTile(
                                            dense: true,
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: listItem
                                                                  .proposedDen !=
                                                              null
                                                          ? Text(
                                                              'Do you want to accept this ₹${listItem.proposedDen} Len from ${listItem.fullName}',style: TextStyle(fontFamily: defaultFont),)
                                                          : Text(
                                                              'Do you want to accept this ₹${listItem.proposedLen} Den to ${listItem.fullName}',style: TextStyle(fontFamily: defaultFont)),
                                                      actions: <Widget>[
                                                        IconButton(
                                                            onPressed:
                                                                () async {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                              setState(() {
                                                                isLoading=true;
                                                              });
                                                              await DatabaseService()
                                                                  .acceptLenDen(
                                                                listItem
                                                                    .friendshipUid,
                                                                listItem.docUid,
                                                                listItem.uid,
                                                                len: listItem
                                                                    .proposedLen,
                                                                den: listItem
                                                                    .proposedDen,
                                                              );

                                                              setState(() {
                                                                notifications
                                                                    .removeAt(
                                                                    index);
                                                                isLoading=false;
                                                              });
                                                              
                                                            },
                                                            icon: Icon(Icons.done_outline)),
                                                        IconButton(
                                                            onPressed:
                                                                () async {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                              setState(() {
                                                                isLoading=true;
                                                              });
                                                              await DatabaseService()
                                                                  .deleteLenDenRequest(
                                                                      listItem
                                                                          .friendshipUid,
                                                                      listItem
                                                                          .docUid);
                                                              setState(() {
                                                                notifications
                                                                    .removeAt(
                                                                    index);
                                                                isLoading=false;
                                                              });

                                                            },
                                                            icon: Icon(Icons.delete,))
                                                      ],
                                                    );
                                                  });
                                            },
                                            title: notifications
                                                        .elementAt(index)
                                                        .proposedLen !=
                                                    null
                                                ? Text('${listItem.fullName} wants to add' +
                                                    ' ' +
                                                    '₹${listItem.proposedLen} to your Den',style: TextStyle(fontFamily: defaultFont),)
                                                : Text('${listItem.fullName} wants to add' +
                                                    ' ' +
                                                    '₹${listItem.proposedDen} to your Len',style: TextStyle(fontFamily: defaultFont)),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        );
                                })
                            : SpinKitChasingDots(color: Colors.black, size: 50),
                      ),
                      placementWidget(
                        start: 74,
                        top: 267,
                        width: 273,
                        height: 136,
                        child: snapP.hasData
                            ? ListView.builder(
                                itemCount: notificationsPayments.length,
                                itemBuilder: (context, index) {
                                  var listItem =
                                      notificationsPayments.elementAt(index);
                                  return listItem.uid != user.uid
                                      ? Card(
                                    shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    color: cardColor,
                                          child: ListTile(
                                            dense: true,
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Do you approve this ₹${listItem.payment} payment from ₹${listItem.fullName}',style: TextStyle(fontFamily: defaultFont)),
                                                      actions: <Widget>[
                                                        IconButton(
                                                            icon: Icon(
                                                                Icons.done_outline),
                                                            onPressed:
                                                                () async {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                              setState(() {
                                                                isLoading=true;
                                                              });
                                                              await DatabaseService()
                                                                  .acceptPayment(
                                                                      listItem
                                                                          .friendshipUid,
                                                                      listItem
                                                                          .docUid,
                                                                      listItem
                                                                          .uid,
                                                                      listItem
                                                                          .payment);
                                                              setState(() {
                                                                notificationsPayments
                                                                    .removeAt(
                                                                    index);
                                                                isLoading=false;
                                                              });


                                                            }),
                                                        IconButton(
                                                            icon: Icon(
                                                                Icons.delete),
                                                            onPressed: () async{
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                              setState(() {
                                                                isLoading=true;
                                                              });
                                                              await DatabaseService().deletePaymentRequest(listItem.friendshipUid, listItem.docUid);
                                                              setState(() {
                                                                notificationsPayments
                                                                    .removeAt(
                                                                    index);
                                                                isLoading=false;
                                                              });

                                                            }),
                                                      ],
                                                    );
                                                  });
                                            },
                                            title: Text(
                                                '${listItem.fullName} claims to have paid ₹${listItem.payment}',style: TextStyle(fontFamily: defaultFont)),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0,
                                        );
                                })
                            : SpinKitChasingDots(color: Colors.black, size: 50),
                      ),
                      placementWidget(
                        start: 29,
                        top: 461,
                        height: 136,
                        width: 273,
                        child: snapFR.hasData
                            ? ListView.builder(
                                itemCount: snapFR.data.length,
                                itemBuilder: (context, index) {
                                  var otherUsers = snapFR.data.elementAt(index);
                                  return Card(
                                    shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    color: cardColor,
                                    child: ListTile(
                                      dense: true,
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Do you want to add ${otherUsers.fullName} as friend ?',style: TextStyle(fontFamily: defaultFont)),
                                                  actions: <Widget>[
                                                    IconButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {
                                                            isLoading=true;
                                                          });
                                                          await DatabaseService(
                                                                  uid: user.uid,
                                                                  usrFullName: user
                                                                      .fullName)
                                                              .addFriends(
                                                                  otherUsers
                                                                      .uid,
                                                                  otherUsers
                                                                      .fullName);

                                                          setState(() {
                                                            isLoading=false;
                                                          });

                                                        },
                                                        icon: Icon(Icons.person_add)),
                                                   IconButton(
                                                        onPressed: () async{
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {
                                                            isLoading=true;
                                                          });
                                                          await DatabaseService().rejectOrDeleteFriendRequest(otherUsers.friendshipUid);

                                                          setState(() {
                                                            isLoading=false;
                                                          });
                                                        },

                                                        icon: Icon(Icons.delete))
                                                  ],
                                                );
                                              });
                                        },
                                        title: Text(
                                          'Friend Request from ' +
                                              snapFR.data
                                                  .elementAt(index)
                                                  .fullName,style: TextStyle(fontFamily: defaultFont)
                                        )),
                                  );
                                })
                            : SpinKitChasingDots(color: Colors.black, size: 50),
                      ),
                      Positioned.fill(
                          child: isLoading
                              ? Loading(loadingColor: bgColorBottom,)
                              : SizedBox(
                            height: 0,
                            width: 0,
                          ))
                    ],
                  );
                },
              );
            },
          );
        });
  }
}
