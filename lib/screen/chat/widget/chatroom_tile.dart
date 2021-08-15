import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/providers/chat_provider.dart';
import 'package:kilifi_county_admin/screen/chat/chat.dart';

import 'package:kilifi_county_admin/screen/chat/widget/chatscreen.dart';
import 'package:provider/provider.dart';

class ChatroomTile extends StatelessWidget {
  final String userId;
  final String imageUrl;
  final String fullName;
  final String username;
  final String nationalId;
  final String phonenumber;
  final bool isVerified;
  final String email;
  final String subCounty;
  final String latestMessage;
  final Timestamp time;

  const ChatroomTile(
      {this.userId,
      this.imageUrl,
      this.fullName,
      this.username,
      this.latestMessage,
      this.nationalId,
      this.phonenumber,
      this.isVerified,
      this.time,
      this.email,
      this.subCounty});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: 150,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: CachedNetworkImageProvider(imageUrl),
          ),
          title: Row(
            children: [
              Text(fullName),
              SizedBox(
                width: 2,
              ),
              if (isVerified)
                Icon(
                  Icons.verified,
                  color: Colors.blue,
                  size: 13,
                )
            ],
          ),
          subtitle: Container(
              height: 23,
              child: Text(
                latestMessage,
                overflow: TextOverflow.fade,
                softWrap: true,
              )),
          onTap: () => size.width > 648
              ? {
                  Provider.of<ChatProvider>(context, listen: false)
                      .getChat(ChatModel(
                    email: email,
                    fullName: fullName,
                    imageUrl: imageUrl,
                    isVerified: isVerified,
                    nationalId: nationalId,
                    phonenumber: phonenumber,
                    subCounty: subCounty,
                    userId: userId,
                    username: username,
                  ))
                }
              : {
                  Provider.of<ChatProvider>(context, listen: false)
                      .getChat(ChatModel(
                    email: email,
                    fullName: fullName,
                    imageUrl: imageUrl,
                    isVerified: isVerified,
                    nationalId: nationalId,
                    phonenumber: phonenumber,
                    subCounty: subCounty,
                    userId: userId,
                    username: username,
                  )),
                  Navigator.of(context).pushNamed(ChatScreen.routeName,
                      arguments: ChatModel(
                        email: email,
                        fullName: fullName,
                        imageUrl: imageUrl,
                        isVerified: isVerified,
                        nationalId: nationalId,
                        phonenumber: phonenumber,
                        subCounty: subCounty,
                        userId: userId,
                        username: username,
                      ))
                },
          trailing: Column(
            children: [
              Text(
                DateFormat('HH:mm').format(
                  time.toDate(),
                ),
                style: font().copyWith(fontSize: 12),
              ),
              SizedBox(
                height: 8,
              ),
              CircleAvatar(
                radius: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
