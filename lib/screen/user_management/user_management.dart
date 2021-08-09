import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/screen/drawer.dart';
import 'package:kilifi_county_admin/screen/user_management/user_management_container.dart';
import 'package:kilifi_county_admin/screen/user_management/user_management_side.dart';

class UserManagement extends StatelessWidget {
  static const routeName = '/user-management';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: UserManagementContainer()),
          UserManagementSide()
        ],
      ),
    );
  }
}
