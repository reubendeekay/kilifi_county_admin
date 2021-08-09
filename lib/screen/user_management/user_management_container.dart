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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TotalUsersTile(),
              TotalUsersTile(
                title: 'Total Admin Users',
                description:
                    'These are all users that have admin status and privileges',
                number: 6,
                picture: 'admin1.png',
              ),
              TotalUsersTile(
                title: 'Total Verified Users',
                picture: 'news_cat.png',
                description: 'These are users that verified accounts',
                number: 10,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [AddAdminCard(), AddVerificationCard()],
          ),
          Row(
            children: [AdminUsers(), VerifiedUsers()],
          )
        ],
      ),
    );
  }
}
