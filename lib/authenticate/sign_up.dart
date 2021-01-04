import 'package:expire_item/service/auth.dart';
import 'package:expire_item/shared/constant.dart';
import 'package:expire_item/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();
  bool _loading = false;
  bool _pwVisible = false;
  String _username;
  String _email;
  String _password;
  String _mobile;
  //focus node
  FocusNode _emailFN = FocusNode();
  FocusNode _passwordFN = FocusNode();
  FocusNode _mobileFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: c1,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context)),
            ),
            backgroundColor: c1,
            body: SafeArea(
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.white),
                          decoration: textInputDecoration2.copyWith(
                            hintText: 'Username',
                            prefixIcon: Icon(Icons.person, color: c3),
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter vaild username' : null,
                          onChanged: (value) => setState(() {
                            _username = value;
                          }),
                          onFieldSubmitted: (val) {
                            FocusScope.of(context).requestFocus(_emailFN);
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: _emailFN,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: textInputDecoration2.copyWith(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.mail_outline, color: c3),
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter vaild email address' : null,
                          onChanged: (value) => setState(() {
                            _email = value;
                          }),
                          onFieldSubmitted: (val) {
                            FocusScope.of(context).requestFocus(_passwordFN);
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          focusNode: _passwordFN,
                          obscureText: !_pwVisible,
                          style: TextStyle(color: Colors.white),
                          decoration: textInputDecoration2.copyWith(
                            hintText: 'Password',
                            prefixIcon:
                                Icon(Icons.lock_outline_rounded, color: c3),
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
                          ),
                          validator: (val) =>
                              val.length <= 6 ? 'Enter 6+ char password' : null,
                          onChanged: (value) => setState(() {
                            _password = value;
                          }),
                          onFieldSubmitted: (val) {
                            FocusScope.of(context).requestFocus(_mobileFN);
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                            focusNode: _mobileFN,
                            style: TextStyle(color: Colors.white),
                            decoration: textInputDecoration2.copyWith(
                              hintText: 'Mobile',
                              prefixIcon: Icon(Icons.phone, color: c3),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (val) => val.length != 10
                                ? 'Enter 10 digit mobie number'
                                : null,
                            onChanged: (value) => setState(() {
                                  _mobile = value;
                                })),
                        SizedBox(height: 15.0),
                        Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                  onPressed: () async {
                                    if (_formkey.currentState.validate()) {
                                      setState(() => _loading = true);
                                      dynamic user = await AuthService()
                                          .registerWithEmailAndPassword(_email,
                                              _password, _mobile, _username);
                                      if (user != null) {
                                        Navigator.pop(context);
                                      } else {
                                        setState(() => _loading = false);
                                      }
                                    }
                                  },
                                  shape: Border.all(color: c3),
                                  child: Text('CREATE ACCOUNT',
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 100.0,
                        ),
                        FlatButton.icon(
                            icon: Icon(FontAwesomeIcons.google, color: c3),
                            onPressed: () async {
                              setState(() => _loading = true);
                              dynamic user =
                                  await AuthService().signInWithGoogle();
                              setState(() => _loading = false);
                              if (user == null) {
                                setState(() => _loading = false);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            shape: Border.all(color: c3),
                            label: Text('Sign in with Google',
                                style: TextStyle(
                                    color: Colors.white, letterSpacing: 1))),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
