import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

class AddChatTile extends StatelessWidget {
  final String userId;
  AddChatTile(this.userId);
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Divider(
          thickness: 0.5,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          width: size.width,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message here ...',
                        prefixIcon: Icon(
                          Icons.attachment,
                          color: Colors.grey,
                        ),
                      ),
                      onEditingComplete: sendMessage,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: sendMessage,
                child: CircleAvatar(
                  backgroundColor: kPrimary,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void sendMessage() {
    final uid = FirebaseAuth.instance.currentUser.uid;
    if (messageController.text.isNotEmpty)
      FirebaseFirestore.instance
          .collection('interactions')
          .doc('chats')
          .collection('messages')
          .doc('consultation')
          .collection(userId)
          .doc()
          .set({
        'message': messageController.text,
        'status': 'delivered',
        'userId': uid,
        'createdAt': Timestamp.now()
      }, SetOptions(merge: true));
    messageController.clear();
  }
}
