import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/providers/user_provider.dart';
import 'package:kilifi_county_admin/screen/start_screen.dart';
import 'package:provider/provider.dart';

class TopUser extends StatefulWidget {
  @override
  _TopUserState createState() => _TopUserState();
}

class _TopUserState extends State<TopUser> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UsersProvider>(context, listen: false).user;

    return AnimatedContainer(
      duration: Duration(milliseconds: 1400),
      curve: Curves.fastLinearToSlowEaseIn,
      margin: EdgeInsets.all(15),
      height: isTapped ? 260 : 90,
      decoration: isTapped
          ? kBox.copyWith(color: Colors.white.withOpacity(0.25))
          : null,
      width: 270,
      padding: EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 20,
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.fullName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        if (user.isVerified)
                          Icon(Icons.verified, size: 13, color: Colors.blue),
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(
                      user.email,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(width: 25),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isTapped = !isTapped;
                    });
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
            if (isTapped)
              AnimatedContainer(
                  duration: Duration(milliseconds: 1400),
                  child: Column(
                    children: [
                      details('Email ', user.email),
                      details('Phone number', user.phoneNumber),
                      details('National ID', user.nationalId),
                      details('Sub County', user.subCounty),
                      SizedBox(
                        height: 15,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context)
                              .pushReplacementNamed(StartScreen.routeName);
                        },
                        color: kPrimary,
                        child: Text(
                          'Log out',
                          style: font(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ))
          ],
        ),
      ),
    );
  }

  Widget details(String title, String data) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.all(7.5),
        child: Row(
          children: [
            Container(
              width: 100,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: font().copyWith(color: Colors.grey),
              ),
            ),
            Spacer(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                data,
                textAlign: TextAlign.start,
                style: font().copyWith(fontWeight: FontWeight.w500),
              ),
            )
          ],
        ));
  }
}
