import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/helpers/footer.dart';
import 'package:kilifi_county_admin/screen/drawer.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  double logoMargin;
  double textFieldPadding;
  double footerPosition;

  @override
  void initState() {
    // TODO: implement initState
    logoMargin = 5;
    textFieldPadding = 70;
    footerPosition = 30;
    super.initState();
  }

  void animate() {
    setState(() {
      logoMargin = 50;
      textFieldPadding = 20;
      footerPosition = 1;
    });
  }

  final _formKey = GlobalKey<FormState>();
  String email = '';

  String password = '';
  Future<void> _trySubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      Navigator.of(context).pushReplacementNamed(Home.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          if (size.width > 648)
            Container(
                width: size.width * 0.5,
                height: double.infinity,
                child:
                    // Image.asset('assets/images/wallpaper.jpg', fit: BoxFit.cover),
                    SvgPicture.asset(
                  'assets/images/back.svg',
                  fit: BoxFit.fill,
                )),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.1, vertical: 10),
            child: Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 2),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: logoMargin,
                      child: FutureBuilder(
                          future: Future.delayed(Duration.zero)
                              .then((value) => animate()),
                          builder: (_, d) => Container()),
                    ),
                    Container(
                      height: 130,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                        child: Text(
                      'Login',
                      style: font(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                      child: AnimatedPadding(
                        duration: Duration(seconds: 1),
                        padding:
                            EdgeInsets.symmetric(horizontal: textFieldPadding),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'email',
                              // border: InputBorder.none,
                              suffixIcon: Icon(
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
                      // shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                      child: AnimatedPadding(
                        duration: Duration(seconds: 1),
                        padding:
                            EdgeInsets.symmetric(horizontal: textFieldPadding),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'password',
                              // border: InputBorder.none,
                              suffixIcon: Icon(
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
                        height: 40,
                        width: size.width * 0.15,
                        child: RaisedButton(
                          onPressed: () async => await _trySubmit(),
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
                    AnimatedContainer(
                      duration: Duration(
                        seconds: 2,
                      ),
                      height: footerPosition,
                      child: Container(
                        width: 1,
                      ),
                    ),
                    Footer()
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
