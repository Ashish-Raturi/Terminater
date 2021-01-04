import 'package:expire_item/home/thankpage.dart';
import 'package:expire_item/service/Database/contact_us.dart';
import 'package:expire_item/shared/constant.dart';
import 'package:expire_item/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final _formkey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _subject;
  String _message;
  bool _showLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return _showLoading
        ? Loading()
        : Scaffold(
            backgroundColor: c2,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Stack(children: [
                  Positioned(
                    right: 10.0,
                    top: 10.0,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Image.asset(
                        'assets/icons/cross.png',
                        fit: BoxFit.cover,
                        height: 20.0,
                        width: 20.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 40.0,
                        ),
                        Text('GET IN TOUCH',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28.0,
                                fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          initialValue: user.displayName,
                          validator: (val) =>
                              val.isEmpty ? 'Enter your name' : null,
                          decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.black87),
                              alignLabelWithHint: true),
                          onChanged: (val) {
                            setState(() {
                              _name = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          initialValue: user.email,
                          validator: (val) =>
                              val.isEmpty ? 'Enter your email address' : null,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black87),
                              alignLabelWithHint: true),
                          onChanged: (val) {
                            setState(() {
                              _email = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Enter subject' : null,
                          decoration: InputDecoration(
                              labelText: 'Subject',
                              labelStyle: TextStyle(color: Colors.black87),
                              alignLabelWithHint: true),
                          onChanged: (val) {
                            setState(() {
                              _subject = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          maxLines: 2,
                          validator: (val) =>
                              val.isEmpty ? 'Enter massage' : null,
                          decoration: InputDecoration(
                              labelText: 'Message',
                              labelStyle: TextStyle(color: Colors.black87),
                              alignLabelWithHint: true),
                          onChanged: (val) {
                            setState(() {
                              _message = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text('I AM SOCIAL',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28.0,
                                fontWeight: FontWeight.w500)),
                        Divider(
                          indent: 100.0,
                          endIndent: 100.0,
                          color: Colors.black,
                          thickness: 2.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //gmail
                            GestureDetector(
                              onTap: () async {
                                const url = 'mailto:ashishraturi368@gmail.com';
                                // 'mailto:ashishraturi368@gmail.com?subject=Greetings&body=Hello%20World'
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: CircleAvatar(
                                radius: 20.0,
                                child: Image.asset(
                                  'assets/icons/gmail.png',
                                  fit: BoxFit.cover,
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            //instagram
                            GestureDetector(
                              onTap: () async {
                                print('Instagarm');
                                const url =
                                    'https://www.instagram.com/dark_wolf883?r=nametag';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: CircleAvatar(
                                radius: 20.0,
                                child: Image.asset(
                                  'assets/icons/instagram.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            //twitter
                            GestureDetector(
                              onTap: () async {
                                print('Instagarm');
                                const url =
                                    'https://twitter.com/AshishRaturi0?s=03';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: CircleAvatar(
                                radius: 20.0,
                                child: Image.asset(
                                  'assets/icons/twitter.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25.0,
                        )
                      ],
                    ),
                  ),
                ]),
              ),
            )),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: c1,
              label: Text(
                'Send',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_formkey.currentState.validate()) {
                  setState(() {
                    _showLoading = true;
                  });
                  var docId = await ContactUsDbService().addUserData(
                      _name ?? user.displayName,
                      _email ?? user.email,
                      _subject,
                      _message);
                  if (docId != null) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ThankPage()));
                    print('Message Send');
                  } else {
                    setState(() {
                      _showLoading = false;
                    });
                  }
                }
              },
            ));
  }
}
