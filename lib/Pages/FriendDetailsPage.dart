import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_hello_world/inter_PageStreams.dart';
import 'package:flutter_hello_world/loading.dart';
import 'package:flutter_hello_world/support.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import 'package:flutter_hello_world/authentication.dart';

class FriendDetails extends StatefulWidget {
  final String friendUid, friendName;

  FriendDetails({this.friendUid, this.friendName});

  @override
  _FriendDetailsState createState() => _FriendDetailsState();
}

class _FriendDetailsState extends State<FriendDetails> with AccountPageDesigns {
  var intController = TextEditingController(),
      txtController = TextEditingController(),
      amtPaidController = TextEditingController();
  int lenOrDen, requestedPaid;
  String reason;
  bool isLoading = false;
  Widget bottomSheetPayment(PaymentModel model, String userUid) {
    String sender, reciever;
    if (model.whoPaidUid == userUid) {
      sender = 'You';
      reciever = widget.friendName;
    } else {
      sender = widget.friendName;
      reciever = 'You';
    }
    return Stack(
      children: <Widget>[
        placementWidget(
          height: 63,
          width: 332,
          start: 24,
          top: 20,
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: bgColorBottom,
              ),
              child: Text('$sender paid ₹${model.payment} to $reciever',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: defaultFont,
                      color: bgColorTop,
                      fontWeight: FontWeight.bold))),
        ),
        placementWidget(
            width: 218,
            height: 118,
            start: 24,
            top: 120,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(42),
                    color: bgColorBottom,
                    boxShadow: [
                      BoxShadow(
                        color: bgColorBottom,
                        blurRadius: 10.0,
                      ),
                    ]),
                child: Text('Sent on : ${model.timeSent.toDate().toString()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: defaultFont,
                        color: bgColorTop,
                        fontWeight: FontWeight.bold)))),
        placementWidget(
          width: 218,
          height: 118,
          start: 128,
          top: 244,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(42),
                color: bgColorBottom,
                boxShadow: [
                  BoxShadow(
                    color: bgColorBottom,
                    blurRadius: 10.0,
                  ),
                ]),
            child: model.timeApproved != null
                ? Text(
                    'Approved on : ${model.timeApproved.toDate().toString()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: defaultFont,
                        color: bgColorTop,
                        fontWeight: FontWeight.bold))
                : Text('Yet to be Approved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: defaultFont,
                        color: bgColorTop,
                        fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget bottomSheetLenDen(FriendRecordModel model, String userUid) {
    String sender, reciever;
    if (model.whoSentUid == userUid) {
      sender = 'You';
      reciever = widget.friendName;
    } else {
      sender = widget.friendName;
      reciever = 'You';
    }
    return Stack(
      children: <Widget>[
        placementWidget(
          height: 63,
          width: 332,
          start: 24,
          top: 20,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: bgColorBottom,
            ),
            child: model.len != null
                ? Text('$sender asked ₹${model.len} from $reciever',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: defaultFont,
                        color: bgColorTop,
                        fontWeight: FontWeight.bold))
                : Text('$sender asked to give ₹${model.den} to $reciever',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: defaultFont,
                        color: bgColorTop,
                        fontWeight: FontWeight.bold)),
          ),
        ),
        placementWidget(
            height: 89,
            width: 332,
            start: 24,
            top: 104,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(31),
                    color: bgColorBottom,
                    boxShadow: [
                      BoxShadow(
                        color: bgColorBottom,
                        blurRadius: 10.0,
                      ),
                    ]),
                child: model.reason != ''
                    ? Text(
                        'Reason : ${model.reason}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: defaultFont,
                            color: bgColorTop,
                            fontWeight: FontWeight.bold),
                      )
                    : Text('No Reason for this Len-Den',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: defaultFont,
                            color: bgColorTop,
                            fontWeight: FontWeight.bold)))),
        placementWidget(
            width: 218,
            height: 118,
            start: 24,
            top: 200,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(42),
                    color: bgColorBottom,
                    boxShadow: [
                      BoxShadow(
                        color: bgColorBottom,
                        blurRadius: 10.0,
                      ),
                    ]),
                child: Text('Sent on : ${model.timeSent.toDate().toString()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: defaultFont,
                        color: bgColorTop,
                        fontWeight: FontWeight.bold)))),
        placementWidget(
          width: 218,
          height: 118,
          start: 128,
          top: 314,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(42),
                color: bgColorBottom,
                boxShadow: [
                  BoxShadow(
                    color: bgColorBottom,
                    blurRadius: 10.0,
                  ),
                ]),
            child: model.timeApproved != null
                ? Text(
                    'Approved on : ${model.timeApproved.toDate().toString()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: defaultFont,
                        color: bgColorTop,
                        fontWeight: FontWeight.bold))
                : Text('Yet to be Approved',
                    style: TextStyle(
                        fontFamily: defaultFont,
                        color: bgColorTop,
                        fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: false);
    return WillPopScope(
      onWillPop: () {
        friendsStreamController.add('0');
        return Future(() {
          return false;
        });
      },
      child: StreamBuilder<DocumentSnapshot>(
          stream: DatabaseService(uid: user.uid)
              .bringRecordsOfFriends(widget.friendUid),
          builder: (context, doc) {
            int netLen, netDen, netPay;
            String friendshipUid;
            if (doc.hasData) {
              friendshipUid = doc.data['friendshipUid'];
              if (user.uid == friendshipUid.split(' ').elementAt(0)) {
                netLen = doc.data['netLen'];
                netDen = doc.data['netDen'];
              } else {
                netDen = doc.data['netLen'];
                netLen = doc.data['netDen'];
              }
              netPay = netDen - netLen;
            }
            return doc.hasData
                ? StreamBuilder<List<FriendRecordModel>>(
                    stream:
                        DatabaseService().getSelectedRecord(doc.data.reference),
                    builder: (context, docsData) {
                      int len, den;
                      return docsData.hasData
                          ? StreamBuilder<List<PaymentModel>>(
                              stream: DatabaseService()
                                  .getPaymentList(doc.data.reference),
                              builder: (context, paymentData) {
                                docsData.data.sort((a,b){
                                  if (a.timeSent!=null&&b.timeSent!=null) {
                                    return b.timeSent.microsecondsSinceEpoch-a.timeSent.microsecondsSinceEpoch;
                                  }
                                  else return 0;
                                });
                                if(paymentData.hasData)
                                  {
                                    paymentData.data.sort((a,b){
                                      if (a.timeSent!=null&&b.timeSent!=null) {
                                        return b.timeSent.microsecondsSinceEpoch-a.timeSent.microsecondsSinceEpoch;
                                      }
                                      else return 0;
                                    });
                                  }
                                return Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                        child: Container(
                                      color: bgColorBottom,
                                    )),
                                    placementWidget(
                                      start: 15,
                                      top: 20,
                                      width: 346,
                                      height: 25,
                                      child: Text(
                                        widget.friendName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: bgColorTop,
                                          fontFamily: defaultFont,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    placementWidget(
                                      width: 133,
                                      height: 48,
                                      start: 15,
                                      top: 60,
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(37),
                                            color: bgColorTop),
                                        child: TextField(
                                            textAlign: TextAlign.center,
                                            cursorColor: bgColorBottom,
                                            controller: intController,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: bgColorBottom,
                                                fontFamily: defaultFont),
                                            decoration: InputDecoration(
                                                hintStyle:
                                                    TextStyle(fontSize: 14),
                                                border: InputBorder.none,
                                                hintText: 'Enter Len or Den'),
                                            onChanged: (input) {
                                              setState(() {
                                                lenOrDen =
                                                    int.parse(input).abs();
                                              });
                                            }),
                                      ),
                                    ),
                                    placementWidget(
                                      width: 202,
                                      height: 48,
                                      top: 60,
                                      start: 159,
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(37),
                                            color: bgColorTop),
                                        child: TextField(
                                            textAlign: TextAlign.center,
                                            controller: txtController,
                                            cursorColor: bgColorBottom,
                                            style: TextStyle(
                                                fontFamily: defaultFont,
                                                fontWeight: FontWeight.bold,
                                                color: bgColorBottom),
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Enter Reason if Any'),
                                            onChanged: (input) {
                                              setState(() {
                                                reason = input;
                                              });
                                            }),
                                      ),
                                    ),
                                    placementWidget(
                                      width: 166,
                                      height: 31,
                                      start: 15,
                                      top: 123,
                                      child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          color: cardColorLen,
                                          onPressed: () async {
                                            if (lenOrDen != null &&
                                                lenOrDen != 0) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              intController.clear();
                                              txtController.clear();
                                              await DatabaseService(
                                                      uid: user.uid,
                                                      usrFullName: user
                                                                  .fullName !=
                                                              null
                                                          ? user.fullName
                                                          : await DatabaseService()
                                                              .usrData
                                                              .document(
                                                                  user.uid)
                                                              .get()
                                                              .then((doc) {
                                                              return (doc.data[
                                                                      'firstName'] +
                                                                  ' ' +
                                                                  doc.data[
                                                                      'lastName']);
                                                            }))
                                                  .sendLenDenRequest(
                                                      friendshipUid,
                                                      widget.friendUid,
                                                      widget.friendName,
                                                      len: lenOrDen,
                                                      reason: reason);
                                              setState(() {
                                                isLoading = false;
                                                lenOrDen = 0;
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Add Len',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: bgColorBottom,
                                                fontFamily: defaultFont),
                                          )),
                                    ),
                                    placementWidget(
                                      width: 166,
                                      height: 31,
                                      top: 123,
                                      start: 195,
                                      child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          color: cardColorDen,
                                          onPressed: () async {
                                            if (lenOrDen != null &&
                                                lenOrDen != 0) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              intController.clear();
                                              txtController.clear();
                                              await DatabaseService(
                                                      uid: user.uid,
                                                      usrFullName:
                                                          user.fullName)
                                                  .sendLenDenRequest(
                                                      friendshipUid,
                                                      widget.friendUid,
                                                      widget.friendName,
                                                      den: lenOrDen,
                                                      reason: reason);
                                              setState(() {
                                                lenOrDen = 0;
                                                isLoading = false;
                                              });
                                            }
                                          },
                                          child: Text('Add Den',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  color: bgColorBottom,
                                                  fontFamily: defaultFont))),
                                    ),
                                    placementWidget(
                                      width: 60,
                                      height: 30,
                                      start: 15,
                                      top: 169,
                                      child: AutoSizeText('Net Len :  ₹$netLen',
                                          style: TextStyle(
                                              color: bgColorTop,
                                              fontFamily: defaultFont)),
                                    ),
                                    placementWidget(
                                      width: 60,
                                      height: 30,
                                      start: 301,
                                      top: 169,
                                      child: AutoSizeText('Net Den :  ₹$netDen',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: bgColorTop,
                                              fontFamily: defaultFont)),
                                    ),
                                    placementWidget(
                                      width: 194,
                                      height: 35,
                                      start: 92,
                                      top: 169,
                                      child: Container(
                                        child: netPay <= 0
                                            ? (netPay != 0
                                                ? AutoSizeText(
                                                    'You have ₹${-1 * netPay} to recieve from ${widget.friendName}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: bgColorTop,
                                                        fontFamily:
                                                            defaultFont))
                                                : AutoSizeText(
                                                    'You are clear with '
                                                    '${widget.friendName}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: bgColorTop,
                                                        fontFamily:
                                                            defaultFont)))
                                            : AutoSizeText(
                                                'You have ₹$netPay to pay to ${widget.friendName}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: bgColorTop,
                                                    fontFamily: defaultFont)),
                                      ),
                                    ),
                                    placementWidget(
                                      width: 202,
                                      height: 48,
                                      start: 15,
                                      top: 217,
                                      child: netPay > 0
                                          ? Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(37),
                                                  color: bgColorTop),
                                              child: TextField(
                                                  textAlign: TextAlign.center,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: amtPaidController,
                                                  cursorColor: bgColorBottom,
                                                  style: TextStyle(
                                                      fontFamily: defaultFont,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: bgColorBottom),
                                                  decoration: InputDecoration(
                                                      hintStyle: TextStyle(
                                                          fontSize: 15),
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'Enter the amount you have paid'),
                                                  onChanged: (input) {
                                                    setState(() {
                                                      requestedPaid =
                                                          int.parse(input)
                                                              .abs();
                                                    });
                                                  }),
                                            )
                                          : (netPay == 0
                                              ? AutoSizeText(
                                                  'Sit Idle and Wait for Len-Den to happen',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: bgColorTop,
                                                      fontFamily: defaultFont))
                                              : AutoSizeText(
                                                  'Go!Get Money from ${widget.friendName}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: bgColorTop,
                                                      fontFamily: defaultFont),
                                                )),
                                    ),
                                    placementWidget(
                                      width: 118,
                                      height: 40,
                                      start: 243,
                                      top: 217,
                                      child: netPay > 0
                                          ? RaisedButton(
                                              color: bgColorTop,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              child: Text(
                                                'Request Approval',
                                                style: TextStyle(
                                                    color: bgColorBottom,
                                                    fontFamily: defaultFont),
                                              ),
                                              onPressed: () async {
                                                if (requestedPaid != null &&
                                                    requestedPaid != 0) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  amtPaidController.clear();
                                                  await DatabaseService(
                                                          uid: user.uid,
                                                          usrFullName: user
                                                                      .fullName !=
                                                                  null
                                                              ? user.fullName
                                                              : await DatabaseService()
                                                                  .usrData
                                                                  .document(
                                                                      user.uid)
                                                                  .get()
                                                                  .then((doc) {
                                                                  return (doc.data[
                                                                          'firstName'] +
                                                                      ' ' +
                                                                      doc.data[
                                                                          'lastName']);
                                                                }))
                                                      .sendPaymentApprovalRequest(
                                                          friendshipUid,
                                                          requestedPaid);
                                                  setState(() {
                                                    requestedPaid = 0;
                                                    isLoading = false;
                                                  });
                                                }
                                              },
                                            )
                                          : Image.asset(
                                              'assets/Images/download3.jpg',
                                              alignment: Alignment.center,
                                            ),
                                    ),
                                    placementWidget(
                                      width: 180,
                                      height: 26,
                                      start: 15,
                                      top: 283,
                                      child: Text(
                                        'Len-Den',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: bgColorTop,
                                            fontFamily: defaultFont),
                                      ),
                                    ),
                                    placementWidget(
                                      width: 180,
                                      height: 334,
                                      start: 15,
                                      top: 303,
                                      child: docsData.hasData
                                          ? (docsData.data.length != 0
                                              ? ListView.builder(
                                                  itemCount:
                                                      docsData.data.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var listItem = docsData.data
                                                        .elementAt(index);
                                                    if (listItem.whoSentUid !=
                                                        user.uid) {
                                                      len = listItem.den;
                                                      den = listItem.len;
                                                    } else {
                                                      len = listItem.len;
                                                      den = listItem.den;
                                                    }
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Card(
                                                        margin: EdgeInsets.zero,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18)),
                                                        color: len != null
                                                            ? cardColorLen
                                                            : cardColorDen,
                                                        child: len != null
                                                            ? ListTile(
                                                                dense: true,
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              35)),
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return bottomSheetLenDen(
                                                                            listItem,
                                                                            user.uid);
                                                                      });
                                                                },
                                                                trailing: listItem
                                                                        .isApproved
                                                                    ? Icon(Icons
                                                                        .done)
                                                                    : Icon(Icons
                                                                        .do_not_disturb_on),
                                                                title: Text(
                                                                    '₹$len',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            defaultFont)),
                                                                subtitle: listItem
                                                                            .whoSentUid !=
                                                                        user.uid
                                                                    ? Text(
                                                                        'Asked by ${listItem.whoSentName}',
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                defaultFont,
                                                                            color:
                                                                                bgColorBottom))
                                                                    : Text(
                                                                        'Asked by You',
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                defaultFont,
                                                                            color:
                                                                                bgColorBottom)),
                                                              )
                                                            : ListTile(
                                                                dense: true,
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              35)),
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return bottomSheetLenDen(
                                                                            listItem,
                                                                            user.uid);
                                                                      });
                                                                },
                                                                leading: listItem
                                                                        .isApproved
                                                                    ? Icon(Icons
                                                                        .done)
                                                                    : Icon(Icons
                                                                        .do_not_disturb_on),
                                                                title: Text(
                                                                  '₹$den',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          defaultFont),
                                                                ),
                                                                subtitle: listItem
                                                                            .whoSentUid !=
                                                                        user.uid
                                                                    ? Text(
                                                                        'Asked by ${listItem.whoSentName}',
                                                                        textAlign:
                                                                            TextAlign
                                                                                .end,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                defaultFont,
                                                                            color:
                                                                                bgColorBottom))
                                                                    : Text(
                                                                        'Asked by You',
                                                                        textAlign:
                                                                            TextAlign
                                                                                .end,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                defaultFont,
                                                                            color:
                                                                                bgColorBottom)),
                                                              ),
                                                      ),
                                                    );
                                                  })
                                              : Image.asset(
                                                  'assets/Images/download2.jpg',
                                                  alignment: Alignment.center,
                                                ))
                                          : SpinKitChasingDots(
                                              color: Colors.black, size: 30),
                                    ),
                                    placementWidget(
                                      width: 157,
                                      height: 26,
                                      start: 204,
                                      top: 283,
                                      child: Text(
                                        'Payments',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: bgColorTop,
                                            fontFamily: defaultFont),
                                      ),
                                    ),
                                    placementWidget(
                                      width: 157,
                                      height: 334,
                                      start: 204,
                                      top: 303,
                                      child: paymentData.hasData
                                          ? (paymentData.data.length != 0
                                              ? ListView.builder(
                                                  itemCount:
                                                      paymentData.data.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    String payee, receiver;
                                                    var listItem = paymentData
                                                        .data
                                                        .elementAt(index);
                                                    if (listItem.whoPaidUid !=
                                                        user.uid) {
                                                      payee =
                                                          listItem.whoPaidName;
                                                      receiver = 'You';
                                                    } else {
                                                      payee = 'You';
                                                      receiver =
                                                          widget.friendName;
                                                    }
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Card(
                                                        margin: EdgeInsets.zero,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18)),
                                                        color:
                                                            listItem.whoPaidUid !=
                                                                    user.uid
                                                                ? cardColorLen
                                                                : cardColorDen,
                                                        child: ListTile(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            35)),
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return bottomSheetPayment(
                                                                      listItem,
                                                                      user.uid);
                                                                });
                                                          },
                                                          dense: true,
                                                          isThreeLine: true,
                                                          leading: listItem
                                                                  .isApproved
                                                              ? Icon(Icons.done)
                                                              : Icon(Icons
                                                                  .do_not_disturb_on),
                                                          title: Text(
                                                              '₹${listItem.payment}',
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      defaultFont)),
                                                          subtitle: listItem.isApproved
                                                              ? Text(
                                                                  'Paid by $payee',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          defaultFont,
                                                                      color:
                                                                          bgColorBottom))
                                                              : Text(
                                                                  'Pending Approval by $receiver',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          defaultFont,
                                                                      color:
                                                                          bgColorBottom)),
                                                        ),
                                                      ),
                                                    );
                                                  })
                                              : Image.asset(
                                                  'assets/Images/download2.jpg',
                                                  alignment: Alignment.center,
                                                ))
                                          : SpinKitChasingDots(
                                              color: Colors.black, size: 30),
                                    ),
                                    Positioned.fill(
                                        child: isLoading
                                            ? Loading(
                                                loadingColor: bgColorTop,
                                              )
                                            : SizedBox(
                                                height: 0,
                                                width: 0,
                                              ))
                                  ],
                                );
                              })
                          : SpinKitChasingDots(color: Colors.black, size: 50);
                    })
                : SpinKitChasingDots(color: Colors.black, size: 50);
          }),
    );
  }
}
