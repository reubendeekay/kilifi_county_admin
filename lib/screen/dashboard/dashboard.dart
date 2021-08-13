import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/providers/user_provider.dart';
import 'package:kilifi_county_admin/screen/dashboard/dashboard_container.dart';
import 'package:kilifi_county_admin/screen/dashboard/widgets/small_widgets.dart';
import 'package:kilifi_county_admin/screen/dashboard/widgets/top_user.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser.uid;
    return Container(
        color: Colors.white,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                var data = snapshot.data;

                Provider.of<UsersProvider>(context, listen: false).getUser(
                    UserModel(
                        email: data['email'],
                        isAdmin: data['isAdmin'],
                        fullName: data['fullName'],
                        imageUrl: data['imageUrl'],
                        nationalId: data['nationalId'],
                        phoneNumber: data['phoneNumber'],
                        subCounty: data['subCounty'],
                        userId: data['userId'],
                        office: data['office'],
                        username: data['username'],
                        isVerified: data['isVerified']));
              }
              return ListView(
                children: [
                  Stack(
                    children: [
                      DashboardCarousel(),
                      GreetingsTop(),
                      Positioned(top: 0, right: 0, child: TopUser()),
                    ],
                  ),
                  DashboardContainer()
                ],
              );
            }));
  }
}
