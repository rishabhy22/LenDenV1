import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hello_world/database.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String error;

  User userDet(FirebaseUser user) {
    return ((user != null)
        ? (User(uid: user.uid, fullName: user.displayName))
        : null);
  }

  Stream<User> get user {
    return auth.onAuthStateChanged.map(userDet);
  }

  Future verifyUser(String currPwd)
  async{
    try{
      var credentials=EmailAuthProvider.getCredential(password: currPwd);
      FirebaseUser user=await auth.currentUser();
      return user.reauthenticateWithCredential(credentials);
    }
    catch(error)
    {
      print(error.toString());
      return false;
    }
  }

  Future changePassword(String pwd)
  async{
    try{
      FirebaseUser user=await auth.currentUser();

      return user.updatePassword(pwd);
    }
    catch(error){
      print(error.toString());
      return false;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return userDet(user);
    } catch (error) {
      //this.error=error.toString().substring(40,129);
      print(error.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String firstName, String lastName,
      String email, String password, String usrName) async {
    try {
      final usrUpdateInfo = UserUpdateInfo();
      usrUpdateInfo.displayName = firstName + ' ' + lastName;
      AuthResult result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await user.updateProfile(usrUpdateInfo);
      await DatabaseService(uid: user.uid)
          .createUsrData(firstName, lastName, email, usrName);
      await user.reload();
      return userDet(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

class User {
  final String uid, fullName;

  User({this.uid, this.fullName});
}
