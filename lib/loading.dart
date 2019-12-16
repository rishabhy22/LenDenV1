import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final Color loadingColor;
  Loading({this.loadingColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(child: SpinKitChasingDots(color: loadingColor, size: 50)),
    );
  }
}
