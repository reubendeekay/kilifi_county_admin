import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/providers/chat_provider.dart';

class MyAppBar extends StatelessWidget {
  final ChatModel chat;
  MyAppBar(this.chat);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(chat.imageUrl),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  chat.fullName,
                  style: font()
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                child: Text(
                  'Online',
                  style: font().copyWith(color: Colors.grey),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
