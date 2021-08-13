import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kilifi_county_admin/screen/chat/widget/chatroom_tile.dart';

class Chatroom extends StatefulWidget {
  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        width: size.width > 648 ? 300 : double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for a user',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        )),
                  ),
                ),
              ),
            ),
            searchController.text.isEmpty
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('interactions')
                        .doc('chats')
                        .collection('users')
                        .orderBy('accessedAt')
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        List documents = snapshot.data.docs;
                        return Expanded(
                          child: ListView(
                              children: documents
                                  .map((e) => ChatroomTile(
                                        email: e['email'],
                                        latestMessage: e['latestMessage'],
                                        time: e['accessedAt'],
                                        fullName: e['fullName'],
                                        imageUrl: e['imageUrl'],
                                        isVerified: e['isVerified'],
                                        nationalId: e['nationalId'],
                                        phonenumber: e['phoneNumber'],
                                        subCounty: e['subCounty'],
                                        userId: e['userId'],
                                        username: e['username'],
                                      ))
                                  .toList()),
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('interactions')
                        .doc('chats')
                        .collection('users')
                        .where('fullName',
                            isGreaterThanOrEqualTo: toBeginningOfSentenceCase(
                                searchController.text))
                        .where('fullName',
                            isLessThan: toBeginningOfSentenceCase(
                                searchController.text + 'z'))
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        List documents = snapshot.data.docs;
                        return Expanded(
                          child: ListView(
                              children: documents
                                  .map((e) => ChatroomTile(
                                        email: e['email'],
                                        latestMessage: e['latestMessage'],
                                        time: e['accessedAt'],
                                        fullName: e['fullName'],
                                        imageUrl: e['imageUrl'],
                                        isVerified: e['isVerified'],
                                        nationalId: e['nationalId'],
                                        phonenumber: e['phoneNumber'],
                                        subCounty: e['subCounty'],
                                        userId: e['userId'],
                                        username: e['username'],
                                      ))
                                  .toList()),
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
          ],
        ));
  }
}
