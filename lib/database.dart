import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid, searchedName, usrFullName;

  DatabaseService({
    this.uid,
    this.searchedName,
    this.usrFullName,
  });

  //collection reference
  final CollectionReference usrData = Firestore.instance.collection('AppUsers');
  final CollectionReference friendships =
      Firestore.instance.collection('Friendships');

  Future createUsrData(
      String firstName, String lastName, String email, String usrName) async {
    return await usrData.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'Email': email,
      'usrName': usrName,
      'netLen': 0,
      'netDen': 0
    });
  }

  Future updateUsrData(
      String friendName, int len, int den, int netLen, int netDen) {
    return usrData.document(uid).setData({
      'friendName': friendName,
      'len': len,
      'den': den,
      'netLen': len + netLen,
      'netDen': den + netDen
    });
  }

  Future<bool> isUserNameAvailable(String userName) async {
    bool cond = await usrData
        .where('usrName', isEqualTo: userName)
        .limit(1)
        .getDocuments()
        .then((doc) {
      return doc.documents.length == 0;
    });
    return cond;
  }

  Future<bool> isFriendOrNot(String friendUid) async {
    bool cond1, cond2;
    cond1 = await friendships.document(friendUid + ' ' + uid).get().then((doc) {
      return doc.exists;
    });
    cond2 = await friendships
        .document(uid + ' ' + friendUid)
        .get()
        .then((doc) async {
      return doc.exists;
    });
    return !cond1 && !cond2;
  }

  Future sendFriendRequest(
      String friendUid, String friendName, String friendUserName) async {
    return friendships.document(uid + ' ' + friendUid).setData({
      'friendshipUid': uid + ' ' + friendUid,
      'whoSentUid': uid,
      'toWhomUid': friendUid,
      'whoSentName': usrFullName,
      'whoSentUserName': await usrData.document(uid).get().then((doc) {
        return doc.data['usrName'];
      }),
      'toWhomName': friendName,
      'toWhomUserName': friendUserName,
      'isFriend': false,
      'isNotification': false,
      'netLen': 0,
      'netDen': 0
    });
  }

  Future addFriends(String friendUid, String friendName) async {
    return friendships
        .document(friendUid + ' ' + uid)
        .updateData({'isFriend': true});
  }

  Future sendLenDenRequest(
      String friendshipUid, String friendUid, String friendName,
      {int len, int den, String reason}) {
    DocumentReference docRef =
        friendships.document(friendshipUid).collection('LenDen').document();
    return docRef.setData({
      'isApproved': false,
      'docUid': docRef.documentID,
      'friendshipUid': friendshipUid,
      'whoSentUid': uid,
      'whoSentName': usrFullName,
      'toWhomUid': friendUid,
      'toWhomName': friendName,
      'timeSent': FieldValue.serverTimestamp(),
      'timeApproved': null,
      'len': len,
      'den': den,
      'reason': reason
    });
  }

  Future deleteLenDenRequest(String friendshipUid, String docUid) {
    return friendships
        .document(friendshipUid)
        .collection('LenDen')
        .document(docUid)
        .delete();
  }

  Future rejectOrDeleteFriendRequest(String friendshipUid) {
    return friendships.document(friendshipUid).delete();
  }

  Future deletePaymentRequest(String friendshipUid, String docUid) {
    return friendships
        .document(friendshipUid)
        .collection('Payments')
        .document(docUid)
        .delete();
  }

  Future sendPaymentApprovalRequest(String friendshipUid, int payment) {
    DocumentReference docRef =
        friendships.document(friendshipUid).collection('Payments').document();
    return docRef.setData({
      'isApproved': false,
      'friendshipUid': friendshipUid,
      'docUid': docRef.documentID,
      'whoPaidUid': uid,
      'whoPaidName': usrFullName,
      'value': payment,
      'timeSent': FieldValue.serverTimestamp(),
      'timeApproved': null
    });
  }

  Future acceptPayment(String friendshipUid, String docUid, String whoPaidUid,
      int payment) async {
    DocumentReference docRef = friendships.document(friendshipUid);

    String first = friendshipUid.split(' ').elementAt(0);
    String second = friendshipUid.split(' ').elementAt(1);
    if (first == whoPaidUid) {
      int netDen;
      await usrData
          .document(first)
          .updateData({'netDen': FieldValue.increment(-1 * payment)});
      await usrData
          .document(second)
          .updateData({'netLen': FieldValue.increment(-1 * payment)});
      await usrData.document(first).get().then((doc) async{
        int k = doc.data['netDen'];
        k < 0
            ? usrData.document(first).updateData(
            {'netLen': FieldValue.increment(k.abs()), 'netDen': 0})
            : Future.delayed(Duration(microseconds: 1));
      });
      await usrData.document(second).get().then((doc) {
        int k = doc.data['netLen'];
        k < 0
            ? usrData.document(second).updateData(
                {'netDen': FieldValue.increment(k.abs()), 'netLen': 0})
            : Future.delayed(Duration(microseconds: 1));
      });
      await docRef.updateData({'netDen': FieldValue.increment(-1 * payment)});
      await docRef.get().then((doc) {
        netDen = doc.data['netDen'];
        netDen < 0
            ? docRef.updateData(
                {'netLen': FieldValue.increment(netDen.abs()), 'netDen': 0})
            : Future.delayed(Duration(microseconds: 1));
      });
    } else {
      int netLen;
      await usrData
          .document(first)
          .updateData({'netLen': FieldValue.increment(-1 * payment)});
      await usrData
          .document(second)
          .updateData({'netDen': FieldValue.increment(-1 * payment)});
     await usrData.document(first).get().then((doc) {
        int k = doc.data['netLen'];
        k < 0
            ? usrData.document(first).updateData(
            {'netDen': FieldValue.increment(k.abs()), 'netLen': 0})
            : Future.delayed(Duration(microseconds: 1));
      });
      await usrData.document(second).get().then((doc) {
        int k = doc.data['netDen'];
        k < 0
            ? usrData.document(second).updateData(
            {'netLen': FieldValue.increment(k.abs()), 'netDen': 0})
            : Future.delayed(Duration(microseconds: 1));
      });
      await docRef.updateData({
        'netLen': FieldValue.increment(-1 * payment),
      });
      await docRef.get().then((doc) {
        netLen = doc.data['netLen'];
        netLen < 0
            ? docRef.updateData(
                {'netDen': FieldValue.increment(netLen.abs()), 'netLen': 0})
            : Future.delayed(Duration(microseconds: 1));
      });
    }
    int payLength;
    await docRef.collection('Payments').getDocuments().then((docs) {
      payLength = docs.documents.length;
      if (payLength > 50) {
        docRef
            .collection('Payments')
            .orderBy('timeApproved')
            .limit(payLength - 50)
            .getDocuments()
            .then((docs) {
          return docs.documents.forEach((doc) {
            return doc.reference.delete();
          });
        });
      }
    });
    return docRef.collection('Payments').document(docUid).updateData(
        {'isApproved': true, 'timeApproved': FieldValue.serverTimestamp()});
  }

  Future acceptLenDen(String friendshipUid, String docUid, String whoSentUid,
      {int len, int den}) async {
    DocumentReference docRef = friendships.document(friendshipUid);

    String first = friendshipUid.split(' ').elementAt(0);
    String second = friendshipUid.split(' ').elementAt(1);
    if (first == whoSentUid) {
      await usrData.document(first).updateData({
        'netLen':
            len != null ? FieldValue.increment(len) : FieldValue.increment(0),
        'netDen':
            den != null ? FieldValue.increment(den) : FieldValue.increment(0)
      });
      await usrData.document(second).updateData({
        'netDen':
            len != null ? FieldValue.increment(len) : FieldValue.increment(0),
        'netLen':
            den != null ? FieldValue.increment(den) : FieldValue.increment(0)
      });
      await docRef.updateData({
        'netLen':
            len != null ? FieldValue.increment(len) : FieldValue.increment(0),
        'netDen':
            den != null ? FieldValue.increment(den) : FieldValue.increment(0)
      });
    } else {
      await usrData.document(first).updateData({
        'netDen':
            len != null ? FieldValue.increment(len) : FieldValue.increment(0),
        'netLen':
            den != null ? FieldValue.increment(den) : FieldValue.increment(0)
      });
      await usrData.document(second).updateData({
        'netLen':
            len != null ? FieldValue.increment(len) : FieldValue.increment(0),
        'netDen':
            den != null ? FieldValue.increment(den) : FieldValue.increment(0)
      });
      await docRef.updateData({
        'netLen':
            den != null ? FieldValue.increment(den) : FieldValue.increment(0),
        'netDen':
            len != null ? FieldValue.increment(len) : FieldValue.increment(0)
      });
    }
    int ldLength;
    await docRef.collection('LenDen').getDocuments().then((docs) {
      ldLength = docs.documents.length;
      if (ldLength > 100) {
        docRef
            .collection('LenDen')
            .orderBy('timeApproved')
            .limit(ldLength - 100)
            .getDocuments()
            .then((docs) {
          return docs.documents.forEach((doc) {
            return doc.reference.delete();
          });
        });
      }
    });
    return docRef.collection('LenDen').document(docUid).updateData(
        {'isApproved': true, 'timeApproved': FieldValue.serverTimestamp()});
  }

  Stream<Iterable<Query>> get showLenDenRequest {
    return friendships.snapshots().map((snap) {
      return snap.documents.where((aDoc) {
        return aDoc.documentID.contains(uid) && aDoc.data['isFriend'];
      }).map((doc) {
        return doc.reference
            .collection('LenDen')
            .where('isApproved', isEqualTo: false);
      });
    });
  }

  Stream<Iterable<Query>> get showLenDenRequestAtAcc {
    return friendships.snapshots().map((snap) {
      return snap.documents.where((aDoc) {
        return aDoc.documentID.contains(uid) && aDoc.data['isFriend'];
      }).map((doc) {
        return doc.reference
            .collection('LenDen')
            .orderBy('timeSent', descending: true)
            .limit(20);
      });
    });
  }

  Stream<Iterable<Query>> get showPayments {
    return friendships.snapshots().map((snap) {
      return snap.documents.where((aDoc) {
        return aDoc.documentID.contains(uid) && aDoc.data['isFriend'];
      }).map((doc) {
        return doc.reference
            .collection('Payments')
            .where('isApproved', isEqualTo: false);
      });
    });
  }

  Stream<List<NotificationModel>> get showFriendRequest {
    return friendships.snapshots().map((snap) {
      return snap.documents.where((aDoc) {
        return (aDoc.documentID.endsWith(uid)) && (!aDoc.data['isFriend']);
      }).map((doc) {
        return NotificationModel(
          friendshipUid: doc.data['friendshipUid'] ?? '',
          fullName: doc.data['whoSentName'] ?? '',
          uid: doc.data['whoSentUid'] ?? '',
        );
      }).toList();
    });
  }

  Stream<List<OtherUsers>> get showFriendsToAdd {
    return usrData.snapshots().map((snap) {
      return snap.documents.where((aDoc) {
        final regExp = RegExp(searchedName);
        return searchedName != '' &&
            uid != aDoc.documentID &&
            regExp
                .hasMatch(aDoc.data['firstName'] + ' ' + aDoc.data['lastName']);
      }).map((doc) {
        return OtherUsers(
            userName: doc.data['usrName'] ?? '',
            fullName: doc.data['firstName'] + ' ' + doc.data['lastName'],
            uid: doc.documentID);
      }).toList();
    });
  }

  Stream<DocumentSnapshot> bringRecordsOfFriends(
      String tappedFriendUid) {
    return friendships.snapshots().map((snap) {
      return snap.documents.singleWhere((aDoc) {
        return aDoc.documentID.contains(uid) &&
            aDoc.documentID.contains(tappedFriendUid);
      });
    });
  }

  Stream<List<FriendRecordModel>> getSelectedRecord(DocumentReference docRef) {
    return docRef.collection('LenDen').snapshots().map((snap) {
      return snap.documents.map((doc) {
        return FriendRecordModel(
            docUid: doc.data['docUid'] ?? '',
            len: doc.data['len'],
            den: doc.data['den'],
            isApproved: doc.data['isApproved'],
            whoSentName: doc.data['whoSentName'] ?? '',
            whoSentUid: doc.data['whoSentUid'] ?? '',
            reason: doc.data['reason'] ?? '',
            timeSent: doc.data['timeSent'],
            timeApproved: doc.data['timeApproved']);
      }).toList();
    });
  }

  Stream<List<PaymentModel>> getPaymentList(DocumentReference docRef) {
    return docRef.collection('Payments').snapshots().map((snap) {
      return snap.documents.map((doc) {
        return PaymentModel(
            docUid: doc.data['docUid'] ?? '',
            payment: doc.data['value'],
            isApproved: doc.data['isApproved'],
            whoPaidName: doc.data['whoPaidName'] ?? '',
            whoPaidUid: doc.data['whoPaidUid'] ?? '',
            timeSent: doc.data['timeSent'],
            timeApproved: doc.data['timeApproved']);
      }).toList();
    });
  }

  Stream<UsrDataModel> get dataOfUsr {
    return usrData.document(uid).snapshots().transform(
        StreamTransformer<DocumentSnapshot, UsrDataModel>.fromHandlers(
            handleData: (src, dest) {
      var data = src.data;
      dest.add(UsrDataModel(
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          netLen: data['netLen'] ?? '',
          netDen: data['netDen'] ?? ''));
    }));
  }

  Stream<List<OtherUsers>> get friends {
    return friendships.snapshots().map((snap) {
      return snap.documents.where((aDoc) {
        final regExp = RegExp(searchedName);
        String reqName;
        if (uid != aDoc.data['whoSentUid']) {
          reqName = aDoc.data['whoSentName'];
        } else {
          reqName = aDoc.data['toWhomName'];
        }
        return aDoc.documentID.contains(uid) &&
            aDoc.data['isFriend'] &&
            regExp.hasMatch(reqName);
      }).map((doc) {
        String reqName, reqUid, reqUserName;
        if (uid != doc.data['whoSentUid']) {
          reqName = doc.data['whoSentName'];
          reqUid = doc.data['whoSentUid'];
          reqUserName=doc.data['whoSentUserName'];
        } else {
          reqName = doc.data['toWhomName'];
          reqUid = doc.data['toWhomUid'];
          reqUserName=doc.data['toWhomUserName'];
        }
        return OtherUsers(
          userName: reqUserName??'',
          fullName: reqName ?? '',
          uid: reqUid ?? '',
        );
      }).toList();
    });
  }
}

class RecentsModel {
  RecentsModel({
    this.toWhomUid,
    this.toWhomName,
    this.whoSentUid,
    this.whoSentName,
    this.proposedLen,
    this.proposedDen,
    this.isApproved,
  });

  final String whoSentUid, whoSentName, toWhomUid, toWhomName;
  final int proposedLen, proposedDen;
  final bool isApproved;
}

class NotificationModel {
  NotificationModel(
      {this.friendshipUid,
      this.uid,
      this.fullName,
      this.payment,
      this.proposedLen,
      this.proposedDen,
      this.docUid});

  final String fullName, uid, docUid, friendshipUid;
  final int proposedLen, proposedDen, payment;
}

class OtherUsers {
  OtherUsers(
      {this.firstName, this.lastName, this.uid, this.fullName, this.userName});

  final String firstName, lastName, fullName, uid, userName;
}

class UsrDataModel {
  UsrDataModel({this.firstName, this.lastName, this.netLen, this.netDen});

  final String firstName, lastName;
  final int netLen, netDen;
}

class FriendRecordModel {
  FriendRecordModel(
      {this.docUid,
      this.len,
      this.den,
      this.isApproved,
      this.whoSentName,
      this.whoSentUid,
      this.reason,
      this.timeApproved,
      this.timeSent});

  final Timestamp timeSent;
  final Timestamp timeApproved;

  final int len, den;
  final String docUid, whoSentName, whoSentUid, reason;
  final bool isApproved;
}

class PaymentModel {
  PaymentModel(
      {this.docUid,
      this.payment,
      this.isApproved,
      this.whoPaidName,
      this.whoPaidUid,
      this.timeApproved,
      this.timeSent});

  final Timestamp timeSent;
  final Timestamp timeApproved;

  final int payment;
  final String docUid, whoPaidName, whoPaidUid;
  final bool isApproved;
}

class Friend {
  Friend({this.friendName, this.friendUid});

  final String friendName, friendUid;
}
