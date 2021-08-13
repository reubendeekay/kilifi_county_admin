import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/dashboard/widgets/new_users.dart';
import 'package:kilifi_county_admin/screen/user_management/widgets/add_admin_card.dart';
import 'package:kilifi_county_admin/screen/user_management/widgets/add_verification_card.dart';
import 'package:kilifi_county_admin/screen/user_management/widgets/admin_users.dart';
import 'package:kilifi_county_admin/screen/user_management/widgets/verified_users.dart';

class UserManagementContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (ctx, snapshots) {
                    if (snapshots.hasData && !snapshots.hasError) {
                      return TotalUsersTile(
                        number: snapshots.data.docs.length,
                      );
                    } else {
                      return TotalUsersTile();
                    }
                  }),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('isAdmin', isEqualTo: true)
                      .snapshots(),
                  builder: (ctx, snapshots) {
                    if (snapshots.hasData && !snapshots.hasError) {
                      return TotalUsersTile(
                        number: snapshots.data.docs.length,
                        title: 'Total Admin Users',
                        description:
                            'These are all users that have admin status and privileges',
                        picture: 'admin1.png',
                      );
                    } else {
                      return TotalUsersTile();
                    }
                  }),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('isVerified', isEqualTo: true)
                      .snapshots(),
                  builder: (ctx, snapshots) {
                    if (snapshots.hasData && !snapshots.hasError) {
                      return TotalUsersTile(
                        number: snapshots.data.docs.length,
                        title: 'Total Verified Users',
                        picture: 'news_cat.png',
                        description: 'These are users that verified accounts',
                      );
                    } else {
                      return TotalUsersTile();
                    }
                  }),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [AddAdminCard(), AddVerificationCard()],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [AdminUsers(), VerificationRequests()],
          )
        ],
      ),
    );
  }
}
