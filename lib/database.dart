import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid, searchedName, usrFullName, tappedFriendUid;

  DatabaseService({this.uid,
    this.searchedName,
    this.usrFullName,
    this.tappedFriendUid,});

  //collection reference
  final CollectionReference usrData = Firestore.instance.collection('AppUsers');
  final CollectionReference friendships =
  Firestore.instance.collection('Friendships');

  Future createUsrData(String firstName, String lastName, String email,
      String usrName) async {
    return await usrData.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'Email': email,
      'usrName': usrName,
      'netLen': 0,
      'netDen': 0
    });
  }

  Future updateUsrData(String friendName, int len, int den, int netLen,
      int netDen) {
    return usrData.document(uid).setData({
      'friendName': friendName,
      'len': len,
      'den': den,
      'netLen': len + netLen,
      'netDen': den + netDen
    });
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

  Future sendFriendRequest(String friendUid, String friendName) async {
    return friendships.document(uid + ' ' + friendUid).setData({
      'friendshipUid': uid + ' ' + friendUid,
      'whoSentUid': uid,
      'whoSentName': usrFullName,
      'toWhomUid': friendUid,
      'toWhomName': friendName,
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

  Future sendLenDenRequest(String friendshipUid,int friendshipIndex ,{int len, int den}) {
    return friendships
        .document(friendshipUid)
        .collection('LenDen').add({
      'isApproved': false,
      'whoSent': friendshipIndex,
      'timeSent': FieldValue.serverTimestamp(),
      'timeApproved': null,
      'len': len,
      'den': den
    });
  }
  Future acceptLenDen(String friendshipUid){

  }

  Stream<List<NotificationModel>> showLenDenRequest(int friend,int friendshipIndex) {

    friendships.snapshots().map((snap){
      return snap.documents.where((docs){
        return docs.documentID.contains(uid)&&docs.data['isFriend'];
      }).map((aDoc){
        return aDoc.reference.collection('LenDen').where('isApproved',isEqualTo: false).snapshots().map((snap){snap.documents.map((doc){
          return ;
        });});
      });
    });
    return friendships
        .document(friendshipUid)
        .collection('LenDen')
        .where('isApproved', isEqualTo: false).where(
        'whoSent', isEqualTo: -1 * friendshipIndex).snapshots().map((snap){
          return snap.documents.map((doc){
            return ;
          }).toList();
    });
  }

  Stream<List<NotificationModel>> get showFriendRequest {
    return friendships.snapshots().map((snap) {
      return snap.documents.where((aDoc) {
        return (aDoc.documentID.endsWith(uid)) &&
            (!aDoc.data['isFriend'] || aDoc.data['isNotification']);
      }).map((doc) {
        return NotificationModel(
          docUid: doc.documentID,
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
            fullName: doc.data['firstName'] + ' ' + doc.data['lastName'],
            uid: doc.documentID);
      }).toList();
    });
  }

  Stream<DocumentSnapshot> get bringRecordsOfFriends {
    return friendships.snapshots().map((snap) {
      return snap.documents.singleWhere((aDoc) {
        return aDoc.documentID.contains(uid) &&
            aDoc.documentID.contains(tappedFriendUid);
      });
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
        String reqName, reqUid;
        if (usrFullName != doc.data['whoSentName']) {
          reqName = doc.data['whoSentName'];
          reqUid = doc.data['whoSentUid'];
        } else {
          reqName = doc.data['toWhomName'];
          reqUid = doc.data['toWhomUid'];
        }
        return OtherUsers(fullName: reqName ?? '', uid: reqUid ?? '');
      }).toList();
    });
  }
}

class NotificationModel {
  NotificationModel({this.uid,
    this.fullName,
    this.proposedLen,
    this.proposedDen,
    this.docUid});

  final fullName, uid, docUid;
  final List<int> proposedLen, proposedDen;
}

class OtherUsers {
  OtherUsers({this.firstName, this.lastName, this.uid, this.fullName});

  final String firstName, lastName, fullName, uid;
}

class UsrDataModel {
  UsrDataModel({this.firstName, this.lastName, this.netLen, this.netDen});

  final String firstName, lastName;
  final int netLen, netDen;
}

class FriendRecordModel {
  FriendRecordModel({this.friendName,
    this.friendUid,
    this.netLen,
    this.netDen,
    this.len,
    this.den});

  List<int> len, den;
  int netLen, netDen;
  final String friendName, friendUid;
}

class Friend {
  Friend({this.friendName, this.friendUid});

  final String friendName, friendUid;
}
