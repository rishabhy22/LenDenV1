import 'package:flutter/material.dart';
import 'package:flutter_hello_world/database.dart';
import 'package:flutter_hello_world/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/inter_PageStreams.dart';

class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SafeArea(
        child: StreamBuilder<UsrDataModel>(
            stream: DatabaseService(uid: user.uid).dataOfUsr,
            builder: (context, snapshot) {
              return Scaffold(
                appBar: AppBar(
                    leading: FlatButton(
                      child: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        streamController.add(0);
                      },
                    ),
                    title: Text('Expenses'),
                    backgroundColor: Color.fromRGBO(230, 65, 64, 1)),
                body: snapshot.hasData
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                  child: Text(
                                'Name : ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              )),
                              Flexible(
                                  flex: 3,
                                  child: Text(
                                      snapshot.data.firstName +
                                          ' ' +
                                          snapshot.data.lastName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 25))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text('Net Money Lent : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25))),
                              Expanded(
                                  child: Text(snapshot.data.netLen.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 25))),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                flex: 3,
                                child: Text('Net Money Borrowed : ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                              ),
                              Expanded(
                                child: Text(snapshot.data.netDen.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 25)),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Loading(),
              );
            }));
  }
}
