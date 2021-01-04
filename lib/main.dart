import 'package:expire_item/service/auth.dart';
import 'package:expire_item/shared/constant.dart';
import 'package:expire_item/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
          color: c1,
          title: 'Expiry',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: c3,
              accentColor: c3,
              hoverColor: c3,
              // cursorColor: Colors.white,
              focusColor: c3,
              disabledColor: c3),
          home: Wrapper()),
    );
  }
}
