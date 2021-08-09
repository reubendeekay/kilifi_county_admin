import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/screen/chat/widget/chatroom.dart';
import 'package:kilifi_county_admin/screen/chat/widget/chatscreen.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Responsive(
        desktop: Row(
          children: [
            Chatroom(),
            Expanded(
              child: ChatScreen(),
            )
          ],
        ),
        tab: Row(
          children: [
            Chatroom(),
            Expanded(
              child: ChatScreen(),
            )
          ],
        ),
        mobile: Chatroom(),
      ),
    );
  }
}
