import 'package:expire_item/models/user_data.dart';
import 'package:expire_item/service/Database/user_database.dart';
import 'package:expire_item/shared/constant.dart';
import 'package:expire_item/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formkey = GlobalKey<FormState>();
  bool _editData = false;
  bool _loading = false;
  bool _pwVisible = false;
  String _name;
  String _email;
  String _mobile;
  String _password;
  String _location;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<AppUserData>(
        stream: UserDbService(uid: user.uid).getUserData,
        builder: (context, snapshot) {
          AppUserData userData = snapshot.data;
          if (snapshot.hasData && _loading == false) {
            return Scaffold(
              backgroundColor: c1,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: c1,
                title: Text('Profile', style: TextStyle(color: Colors.white)),
                actions: [
                  _editData
                      ? IconButton(
                          icon: Icon(Icons.check, color: Colors.white),
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              await UserDbService(uid: user.uid).addUserData(
                                  _email ?? userData.email,
                                  _name ?? userData.name,
                                  _password ?? userData.password,
                                  _mobile ?? userData.mobile,
                                  _location ?? userData.location);
                              print('User Data Updated');
                              setState(() {
                                _loading = false;
                                _editData = false;
                              });
                            }
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _editData = true;
                            });
                          },
                        )
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Form(
                      key: _formkey,
                      child: Column(children: [
                        SizedBox(height: 20.0),
                        Stack(children: [
                          Container(
                            height: 150.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 15.0, // soften the shadow
                                  spreadRadius: 5.0, //extend the shadow
                                  offset: Offset(
                                    5.0, // Move to right 10  horizontally
                                    5.0, // Move to bottom 10 Vertically
                                  ),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: user.photoURL == null
                                    ? AssetImage('assets/icons/profile pic.jpg')
                                    : NetworkImage(user.photoURL),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   right: 10.0,
                          //   top: 15.0,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       print('take image');
                          //     },
                          //     child: Image.asset(
                          //       'assets/icons/take_picture.png',
                          //       fit: BoxFit.cover,
                          //       height: 45.0,
                          //       width: 45.0,
                          //     ),
                          //   ),
                          // ),
                        ]),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80.0, vertical: 10.0),
                          child: TextFormField(
                              textAlign: TextAlign.center,
                              enabled: _editData,
                              initialValue: userData.name,
                              style: TextStyle(color: Colors.white),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter your name' : null,
                              onChanged: (value) => setState(() {
                                    _name = value;
                                  })),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80.0, vertical: 10.0),
                          child: TextFormField(
                              enabled: false,
                              textAlign: TextAlign.center,
                              initialValue: userData.email,
                              style: TextStyle(color: Colors.white),
                              validator: (val) => val.isEmpty
                                  ? 'Enter a vaild email address'
                                  : null,
                              decoration: textInputDecoration,
                              onChanged: (value) => setState(() {
                                    _email = value;
                                  })),
                        ),
                        Divider(
                          color: c3,
                          thickness: 2.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28.0, vertical: 10.0),
                          child: TextFormField(
                              initialValue: userData.mobile,
                              enabled: _editData,
                              style: TextStyle(color: Colors.white),
                              validator: (val) =>
                                  val.length != 10 || val == 'Mobile No'
                                      ? 'Enter 10 digit mobile nuber'
                                      : null,
                              decoration: textInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.phone, color: c3),
                              ),
                              onChanged: (value) => setState(() {
                                    _mobile = value;
                                  })),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28.0, vertical: 10.0),
                          child: TextFormField(
                              initialValue: userData.password,
                              enabled: false,
                              obscureText: !_pwVisible,
                              style: TextStyle(color: Colors.white),
                              validator: (val) => val.length <= 6
                                  ? 'Enter 6+ char password'
                                  : null,
                              decoration: textInputDecoration.copyWith(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _pwVisible = !_pwVisible;
                                    });
                                  },
                                  child: Icon(
                                      _pwVisible
                                          ? FontAwesomeIcons.eyeSlash
                                          : FontAwesomeIcons.eye,
                                      color: c2),
                                ),
                                prefixIcon:
                                    Icon(Icons.lock_outline_rounded, color: c3),
                              ),
                              onChanged: (value) => setState(() {
                                    _password = value;
                                  })),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28.0, vertical: 10.0),
                          child: TextFormField(
                              initialValue: userData.location,
                              style: TextStyle(color: Colors.white),
                              enabled: _editData,
                              validator: (val) =>
                                  val.isEmpty || val == 'Address'
                                      ? 'Enter your addrress'
                                      : null,
                              decoration: textInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.location_on, color: c3),
                              ),
                              onChanged: (value) => setState(() {
                                    _location = value;
                                  })),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
