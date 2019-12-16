import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/FriendWrapper.dart';
import 'package:flutter_hello_world/Pages/Settings.dart';
import 'package:flutter_hello_world/Pages/accountpage.dart';
import 'package:flutter_hello_world/Pages/notifications.dart';
import 'package:flutter_hello_world/Pages/search_friends.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/inter_PageStreams.dart';
import 'package:flutter_hello_world/support.dart';
import 'package:provider/provider.dart';

class AccountPageWrapper extends StatefulWidget {
  @override
  _AccountPageWrapperState createState() => _AccountPageWrapperState();
}

class _AccountPageWrapperState extends State<AccountPageWrapper> with AccountPageDesigns{
  final auth = AuthService();
  int currIndex=2;
  List<String> title=['Notifications','Friends','Len-Den','Add Friends','Settings'];
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:Text(title[currIndex],style: TextStyle(fontFamily: defaultFont,fontWeight: FontWeight.w900),) ,
        actions: <Widget>[
          FlatButton.icon(
            color: Colors.white,
              onPressed: () async {
              streamController.add(-1);
                await auth.signOut();
              },
              icon: Icon(Icons.exit_to_app),
              label: Text('Logout',style: TextStyle(fontFamily: defaultFont,fontWeight: FontWeight.w900)))
        ],
      ),
      body: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: StreamBuilder<int>(
          stream: OpStream().acOp,
          initialData: 2,
          builder: (context,opSnap){
            if(opSnap.hasError)
              return Text('Error: ${opSnap.error}');
            else if(user!=null&&opSnap.hasData)
              {
                switch(opSnap.data)
                {
                  case 0:
                    return Notifications();
                  case 1:
                    return FriendWrapper();
                  case 2:
                    return AccountPage();
                  case 3:
                    return AddFriends();
                  case 4:
                    return Settings();
                }
              }
            return SizedBox();
          },
        ),
      ),
        bottomNavigationBar: CurvedNavigationBar(backgroundColor: Colors.black,items:<Widget> [
          Icon(Icons.notifications),
          Icon(Icons.person),
          Icon(Icons.menu),
          Icon( Icons.person_add),
          Icon(Icons.settings),
        ], onTap: (index) {
          setState(() {
            currIndex=index;
          });
          acStreamController.add(index);
        }
          ,
          index: 2,)
    );
  }
}
