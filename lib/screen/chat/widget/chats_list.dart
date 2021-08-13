import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var chat = Provider.of<ChatProvider>(context).chat;

    return chat != null
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('interactions')
                .doc('chats')
                .collection('messages')
                .doc('consultation')
                .collection(chat.userId)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                List<DocumentSnapshot> documents = snapshot.data.docs;

                return ListView(
                    reverse: true,
                    children: documents
                        .map((e) => ChatBubble(
                              userId: e['userId'],
                              message: e['message'],
                              status: e['status'],
                            ))
                        .toList());
              } else {
                return Container(
                  child: Center(
                    child: Text('No messages'),
                  ),
                );
              }
            })
        : Container();
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String status;
  final String userId;

  ChatBubble({
    this.userId,
    this.message,
    this.status,
  });

  final uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment:
          uid == userId ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          constraints: BoxConstraints(maxWidth: size.width * 0.5),
          decoration: BoxDecoration(
              color: uid == userId ? Colors.grey : kPrimary,
              borderRadius: BorderRadius.only(
                bottomLeft:
                    uid == userId ? Radius.circular(20) : Radius.circular(0),
                bottomRight:
                    uid != userId ? Radius.circular(20) : Radius.circular(0),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          padding: EdgeInsets.all(15),
          child: Text(message),
        ),
      ],
    );
  }
}
