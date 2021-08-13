import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/forum/forum_container.dart';

class LatestPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              'Posted Employment Opportunities',
              style: font().copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          JobOpportunitiesPosts(),
        ],
      ),
    );
  }
}
