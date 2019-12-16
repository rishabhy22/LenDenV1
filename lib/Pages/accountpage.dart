import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_hello_world/support.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPage createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> with AccountPageDesigns {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    return user != null
        ? StreamBuilder<Iterable<Query>>(
            stream: DatabaseService(uid: user.uid).showLenDenRequestAtAcc,
            builder: (context, snapLD) {
              List<RecentsModel> recents = List<RecentsModel>();
              if (snapLD.hasData) {
                snapLD.data.forEach((coll) {
                  coll.snapshots().forEach((docs) {
                    recents.addAll(docs.documents.map((doc) {
                      return RecentsModel(
                          toWhomName: doc.data['toWhomName'] ?? '',
                          toWhomUid: doc.data['toWhomUid'] ?? '',
                          whoSentUid: doc.data['whoSentUid'] ?? '',
                          whoSentName: doc.data['whoSentName'] ?? '',
                          proposedLen: doc.data['len'],
                          proposedDen: doc.data['den'],
                          isApproved: doc.data['isApproved']);
                    }));
                  });
                });
              }
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Container(
                    color: Colors.black,
                  )),
                  placementWidget(
                    start: -45,
                    width: 461,
                    top: -80,
                    height: 366,
                    child: ClipOval(
                        child: Container(
                      decoration: BoxDecoration(color: bgColorTop),
                    )),
                  ),
                  placementWidget(
                    start: 12.5,
                    width: 350,
                    top: 50,
                    height: 90,
                    child: Text(
                      user.fullName != null
                          ? user.fullName
                          : 'Welcome to Len-Den!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: defaultFont,
                          fontSize: 30,
                          wordSpacing: 1,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  placementWidget(
                    start: 72,
                    width: 236,
                    top: 146,
                    height: 236,
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColorBottom,
                        ),
                      ),
                    ),
                  ),
                  placementWidget(
                    start: 84.83,
                    width: 211,
                    top: 158.89,
                    height: 211,
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  placementWidget(
                    start: 113,
                    width: 150,
                    top: 200,
                    height: 100,
                    child: StreamBuilder<UsrDataModel>(
                        stream: DatabaseService(uid: user.uid).dataOfUsr,
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: AutoSizeText('Lent : ',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontFamily: defaultFont,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13))),
                                          Expanded(
                                              child: AutoSizeText(
                                                  '₹' +
                                                      snapshot.data.netLen
                                                          .toString(),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontFamily: defaultFont,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 15))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: AutoSizeText('Borrowed : ',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontFamily: defaultFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13)),
                                          ),
                                          Expanded(
                                            child: AutoSizeText(
                                                '₹' +
                                                    snapshot.data.netDen
                                                        .toString(),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontFamily: defaultFont,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 15)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : SpinKitChasingDots(
                                  color: Colors.black,
                                  size: 50,
                                );
                        }),
                  ),
                  placementWidget(
                    start: 34,
                    top: 390,
                    height: 15,
                    width: 304,
                    child: Text(
                      'Recent',
                      style: TextStyle(
                        color: bgColorTop,
                        fontFamily: defaultFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  placementWidget(
                    start: 34,
                    width: 304,
                    top: 411,
                    height: 193,
                    child: StreamBuilder<Iterable<Query>>(
                        stream: DatabaseService(uid: user.uid)
                            .showLenDenRequestAtAcc,
                        builder: (context, snapLD) {
                          return snapLD.hasData
                              ? (recents.length != 0
                                  ? ListView.builder(
                                      addRepaintBoundaries: false,
                                      itemBuilder: (context, index) {
                                        var listItem = recents.elementAt(index);
                                        String whoSent, toWhom;
                                        int amt;
                                        if (listItem.whoSentUid == user.uid) {
                                          whoSent = 'You';
                                          toWhom = listItem.toWhomName;
                                        } else {
                                          whoSent = listItem.whoSentName;
                                          toWhom = 'You';
                                        }
                                        if (listItem.proposedDen != null)
                                          amt = listItem.proposedDen;
                                        else
                                          amt = listItem.proposedLen;
                                        return Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          22)),
                                              color: bgColorTop,
                                              child: ListTile(
                                                dense: true,
                                                title: listItem.proposedLen !=
                                                        null
                                                    ? Text(
                                                        '$whoSent requested ₹$amt Len from $toWhom',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                bgColorBottom,
                                                            fontFamily:
                                                                defaultFont),
                                                      )
                                                    : Text(
                                                        '$whoSent requested ₹$amt Den to $toWhom',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                bgColorBottom,
                                                            fontFamily:
                                                                defaultFont),
                                                      ),
                                                trailing: listItem.isApproved
                                                    ? Icon(Icons.check_box)
                                                    : Icon(Icons
                                                        .check_box_outline_blank),
                                              )),
                                        );
                                      },
                                      itemCount: recents.length)
                                  : Image.asset(
                                      'assets/Images/download2.jpg',
                                      alignment: Alignment.center,
                                    ))
                              : SpinKitChasingDots(
                                  color: bgColorTop,
                                  size: 50,
                                );
                        }),
                  )
                ],
              );
            })
        : SpinKitChasingDots(
            color: Colors.white,
            size: 50,
          );
  }
}
