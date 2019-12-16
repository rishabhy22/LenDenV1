import 'package:flutter/material.dart';
import 'package:flutter_hello_world/AccountPageWrapper.dart';
import 'package:flutter_hello_world/authenticate.dart';
import 'package:flutter_hello_world/authentication.dart';
import 'package:flutter_hello_world/inter_PageStreams.dart';
import 'package:provider/provider.dart';
import 'inter_PageStreams.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user != null) {
      streamController.add(0);

    } else
      streamController.add(-1);
    return StreamBuilder<int>(
      stream: OpStream().opStream,
      initialData: 0,
      builder: (context, snap) {
        if (snap.hasError)
          return Text('Error: ${snap.error}');
        else if (snap.hasData) {
          switch (snap.data) {
            case 0:
              {
                if (user!=null) {
                  print(user.uid);
                  print(user.fullName);
                }
                return AccountPageWrapper();
              }
            case -1:
              return Authenticate();
          }
        }
        return SizedBox();
      },
    );
  }
}
