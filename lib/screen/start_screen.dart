import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/helpers/footer.dart';
import 'package:kilifi_county_admin/screen/auth_screen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 10, horizontal: size.width * 0.09),
                child: Row(
                  children: [
                    Container(
                      decoration: kBox,
                      height: 30,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        'Kilifi County',
                        style: font(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: size.width * 0.25,
                  margin: EdgeInsets.only(left: size.width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'Admin',
                            style: font(
                              fontSize: 24,
                              color: kPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'Kilifi County',
                            style: font(
                              fontSize: 35,
                              color: kBackground,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      SizedBox(
                        height: 35,
                      ),
                      SizedBox(
                          width: 150,
                          child: Container(
                            decoration: kBox,
                            child: RaisedButton(
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: kBackground,
                                onPressed: () => Navigator.of(context)
                                    .pushReplacementNamed(
                                        AuthScreen.routeName)),
                          )),
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        width: 175,
                        child: Text(
                          'Only authorized personel should access the admin panel.Major decisions will be audited. With great power comes great responsibility.',
                          style: font(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: size.width * 0.11, bottom: 10),
                  child: Footer())
            ],
          ),
          Expanded(
              child: Container(
            height: size.height,
            child: Image.asset(
              'assets/images/phone.gif',
              fit: BoxFit.fitHeight,
            ),
          ))
        ],
      ),
    );
  }
}
