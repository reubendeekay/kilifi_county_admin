import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/providers/post_provider.dart';
import 'package:kilifi_county_admin/providers/user_provider.dart';
import 'package:kilifi_county_admin/screen/forum/widgets/forum_picture_tile.dart';
import 'package:kilifi_county_admin/screen/forum/widgets/forum_text_tile.dart';

class ForumPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData || snapshot.hasError || snapshot.data == null) {
          return CircularProgressIndicator();
        } else {
          List<DocumentSnapshot> documents = snapshot.data.docs;

          List<Widget> forum = [];
          documents.forEach((e) {
            if (e['imageUrl'] != null) {
              forum.add(ForumPictureTile(Post(
                  comments: e['comments'],
                  description: e['description'],
                  id: e['postId'],
                  imageUrl: e['imageUrl'],
                  likes: e['likes'],
                  user: UserModel(
                      fullName: e['fullName'],
                      imageUrl: e['profilePic'],
                      username: e['username'],
                      userId: e['userId'],
                      isVerified: e['isVerified']))));
            } else {
              forum.add(ForumTextTile(Post(
                  comments: e['comments'],
                  description: e['description'],
                  id: e['postId'],
                  likes: e['likes'],
                  user: UserModel(
                      fullName: e['fullName'],
                      imageUrl: e['profilePic'],
                      username: e['username'],
                      userId: e['userId'],
                      isVerified: e['isVerified']))));
            }
          });

          return ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: forum);
        }
      },
    );
  }
}
