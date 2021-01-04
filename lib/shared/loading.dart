import 'package:expire_item/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: c2,
        body: Center(
          child: SpinKitFoldingCube(
            color: c1,
            // size: 42.0,
          ),
        ));
  }
}
