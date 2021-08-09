import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/screen/forum/forum_container.dart';
import 'package:kilifi_county_admin/screen/forum/forum_mobile.dart';
import 'package:kilifi_county_admin/screen/forum/forum_side.dart';

class Forum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Responsive(
        desktop: Row(
          children: [ForumContainer(), ForumSide()],
        ),
        tab: Row(
          children: [ForumContainer(), ForumSide()],
        ),
        mobile: ForumMobile(),
      ),
    );
  }
}
