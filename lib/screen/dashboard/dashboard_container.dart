import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/screen/dashboard/widgets/latest_posts.dart';
import 'package:kilifi_county_admin/screen/dashboard/widgets/new_users.dart';

class DashboardContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [NewUsers(), LatestPosts()],
    ));
  }
}
