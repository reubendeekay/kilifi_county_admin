import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/screen/Resources/resources_list.dart';
import 'package:kilifi_county_admin/screen/Resources/widgets/resources_top.dart';

class Resources extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                child: Container(
              constraints: BoxConstraints(minWidth: 350),
              child: ResourcesSide(),
            )),
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
              child: ResourcesSide(),
            )
          ],
        ),
        mobile: Column(
          children: [ResourcesSide(), ResourcesTop(), ResourcesMobile()],
        ),
      ),
    );
  }
}
