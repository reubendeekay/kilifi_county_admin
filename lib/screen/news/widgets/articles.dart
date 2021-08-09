import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kilifi_county_admin/screen/news/widgets/article_tile.dart';

class ArticlesContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        color: Color.fromRGBO(245, 255, 254, 1),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text('Latest Articles',
                    style: GoogleFonts.tinos(
                        fontWeight: FontWeight.w800, fontSize: 22))),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admin')
                    .doc('admin_data')
                    .collection('news')
                    .orderBy('createdAt')
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    List<DocumentSnapshot> documents = snapshot.data.docs;

                    return Expanded(
                        child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) => ArticleTile(
                        article: documents[i]['article'],
                        index: i + 1,
                        title: documents[i]['title'],
                        date: documents[i]['createdAt'],
                        views: documents[i]['views'],
                        images: documents[i]['images'],
                        username: documents[i]['username'],
                        fullName: documents[i]['fullName'],
                        profilePic: documents[i]['profilePic'],
                        postId: documents[i]['postId'],
                      ),
                      itemCount: documents.length,
                    ));
                  } else {
                    return Container();
                  }
                }),
          ],
        ));
  }
}
