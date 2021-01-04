import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String text, BuildContext context,
    {bool error = false, bool showTick = true}) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0), color: Colors.black87),
    child: Wrap(
      alignment: WrapAlignment.center,
      children: [
        showTick
            ? error
                ? Icon(
                    Icons.error,
                    color: Colors.red,
                  )
                : Image.asset(
                    'assets/icons/right_tick.png',
                    fit: BoxFit.cover,
                    height: 20.0,
                    width: 20.0,
                    color: Colors.white,
                  )
            : SizedBox(),
        SizedBox(
          width: 12.0,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
  );

  fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: 4),
      gravity: ToastGravity.BOTTOM);
}
