import 'package:flutter/material.dart';

Color c1 = const Color(0xff004d40);
Color c2 = const Color(0xffe6e5e5);
Color c3 = const Color(0xffffd45b);

const textInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.white, letterSpacing: 1),

  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Color(0xffffd45b), style: BorderStyle.none,),
  // ),
  // focusedBorder: OutlineInputBorder(
  //     borderSide:
  //         BorderSide(color: Color(0xffffd45b), style: BorderStyle.none)),
);

const textInputDecoration2 = InputDecoration(
    hintStyle: TextStyle(color: Colors.white, letterSpacing: 1),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xffffd45b), width: 1.8)));

const additemtextInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.black, letterSpacing: 1),
  fillColor: Color(0xffe6e5e5),
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffe6e5e5), width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffe6e5e5), width: 2.0)),
);
