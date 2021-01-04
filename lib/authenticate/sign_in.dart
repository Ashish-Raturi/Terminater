import 'package:expire_item/authenticate/sign_up.dart';
import 'package:expire_item/service/auth.dart';
import 'package:expire_item/shared/constant.dart';
import 'package:expire_item/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formkey = GlobalKey<FormState>();
  FocusNode pwdFocusNode = new FocusNode();
  bool _loading = false;
  bool _pwVisible = false;
  String _email;
  String _password;
  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
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
                          decoration: textInputDecoration2.copyWith(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.mail_outline, color: c3),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter vaild email address' : null,
                          onChanged: (value) => setState(
                            () {
                              _email = value;
                            },
                          ),
                          onFieldSubmitted: (val) {
                            FocusScope.of(context).requestFocus(pwdFocusNode);
                          },
                        ),
                        SizedBox(height: 30.0),
                        TextFormField(
                            focusNode: pwdFocusNode,
                            style: TextStyle(color: Colors.white),
                            obscureText: !_pwVisible,
                            validator: (val) => val.length <= 6
                                ? 'Enter 6+ char password'
                                : null,
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
                            onChanged: (value) => setState(() {
                                  _password = value;
                                })),
                        SizedBox(height: 30.0),
                        Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                  onPressed: () async {
                                    if (_formkey.currentState.validate()) {
                                      setState(() => _loading = true);
                                      dynamic user = await AuthService()
                                          .signInWithEmailAndPassword(
                                              _email, _password);
                                      if (user == null) {
                                        setState(() => _loading = false);
                                      }
                                    }
                                  },
                                  shape: Border.all(color: c3),
                                  child: Text('LOGIN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1))),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        RichText(
                            text: TextSpan(
                          text: 'No accout yet ? ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                                text: 'Create one',
                                style: TextStyle(
                                    color: Colors.blue, letterSpacing: 1),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('SignUp');
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()));
                                  }),
                          ],
                        )),
                        // SizedBox(height: 15.0),
                        // GestureDetector(
                        //   onTap: () {
                        //     print('forgot password');
                        //   },
                        //   child: Text('Forgot Password ?',
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           letterSpacing: 1,
                        //           decoration: TextDecoration.underline)),
                        // ),
                        SizedBox(
                          height: 145.0,
                        ),
                        FlatButton.icon(
                            icon: Icon(FontAwesomeIcons.google, color: c3),
                            onPressed: () async {
                              setState(() => _loading = true);
                              dynamic user =
                                  await AuthService().signInWithGoogle();
                              if (user == null) {
                                setState(() => _loading = false);
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
