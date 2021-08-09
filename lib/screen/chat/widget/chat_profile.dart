import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatProfile extends StatelessWidget {
  static const routeName = 'chat-profile';

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatProvider>(context).chat;

    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Center(
              child: CircleAvatar(
                radius: 75,
                backgroundImage: NetworkImage(chat.imageUrl),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Flexible(
                child: Text(
                  chat.fullName,
                  style: font()
                      .copyWith(fontWeight: FontWeight.w900, fontSize: 24),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Flexible(
                child: Text(
                  chat.username,
                  style: font().copyWith(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: Text(
                      'Phone',
                      style: font().copyWith(color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    chat.phonenumber,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: Text(
                      'Email',
                      style: font().copyWith(color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      chat.email,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: Text(
                      'ID',
                      style: font().copyWith(color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    chat.nationalId,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
