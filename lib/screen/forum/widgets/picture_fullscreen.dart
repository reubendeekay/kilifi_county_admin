import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

class PictureFullScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      child: Container(
        width: 800,
        height: 500,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: kBackground.withOpacity(0.2),
              ),
            ),
            Container(
              color: Colors.white,
              width: size.width * 0.3,
              constraints: BoxConstraints(minWidth: 300),
              child: Column(
                children: [
                  Container(
                    height: double.infinity,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
