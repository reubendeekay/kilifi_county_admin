import 'package:flutter/material.dart';

import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/providers/chat_provider.dart';
import 'package:kilifi_county_admin/screen/chat/widget/add_chat_tile.dart';
import 'package:kilifi_county_admin/screen/chat/widget/chat_profile.dart';
import 'package:kilifi_county_admin/screen/chat/widget/chats_list.dart';
import 'package:kilifi_county_admin/screen/chat/widget/my_appbar.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'chat-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isProfileOpen = false;
  @override
  Widget build(BuildContext context) {
    var chat = Provider.of<ChatProvider>(context).chat;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: chat != null
          ? Card(
              elevation: 3,
              child:
                  //  Responsive(
                  //   desktop:
                  size.width > 648
                      ? Stack(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isProfileOpen =
                                                      !isProfileOpen;
                                                });
                                              },
                                              child: MyAppBar(chat)),
                                          Divider(),
                                          Expanded(child: ChatsList()),
                                          AddChatTile(chat.userId)
                                        ],
                                      ),
                                    ),
                                  ),
                                  // if (isProfileOpen)
                                  //   SizedBox(width: 250, child: ChatProfile())
                                ],
                              ),
                            ),
                            if (isProfileOpen)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      width: 260,
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[300],
                                          spreadRadius: 0.5,
                                          blurRadius: 30,
                                        )
                                      ]),
                                      child: ChatProfile()),
                                ],
                              )
                          ],
                        )
                      : Container(
                          child: Container(
                            child: Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          ChatProfile.routeName,
                                          arguments: chat);
                                    },
                                    child: MyAppBar(chat)),
                                Divider(),
                                Expanded(child: ChatsList()),
                                AddChatTile(chat.userId)
                              ],
                            ),
                          ),
                          //   ),
                        ),
            )
          : Card(
              elevation: 5,
            ),
    );
  }
}
