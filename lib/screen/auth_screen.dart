import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';

  String password = '';
  void _trySubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: size.width * 0.54,
            height: double.infinity,
            child:
                Image.asset('assets/images/wallpaper.jpg', fit: BoxFit.cover),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.03, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Container(
                    height: 150,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'email',
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email,
                              color: kBackground,
                            )),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'password',
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: kBackground,
                            )),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      height: 30,
                      width: size.width * 0.25,
                      child: RaisedButton(
                        onPressed: _trySubmit,
                        child: Text(
                          'Sign in',
                          style: font().copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        color: kBackground,
                      )),
                  Spacer(),
                  Container(
                      child: Text(
                    '*Only admins can log in. With great power,comes great responsibility',
                    style: font().copyWith(
                        fontSize: 12,
                        color: kBackground,
                        fontStyle: FontStyle.italic),
                  ))
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
