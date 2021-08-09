import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/screen/Resources/resources_list.dart';
import 'package:kilifi_county_admin/screen/Resources/widgets/resources_top.dart';

class Resources extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Responsive(
        desktop: Row(
          children: [
            Container(
              color: Colors.grey[50],
              child: Column(
                children: [ResourcesTop(), Expanded(child: ResourcesList())],
              ),
            ),
            Expanded(
                child: Card(
              child: ResourcesSide(),
            ))
          ],
        ),
        tab: Row(
          children: [
            Container(
              color: Colors.grey[50],
              child: Column(
                children: [ResourcesTop(), Expanded(child: ResourcesList())],
              ),
            ),
            Expanded(
                child: Card(
              child: ResourcesSide(),
            ))
          ],
        ),
        mobile: ListView(
          children: [ResourcesSide(), ResourcesTop(), ResourcesMobile()],
        ),
      ),
    );
  }
}
