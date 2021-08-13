import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/models/news_model.dart';
import 'package:kilifi_county_admin/screen/news/add_article.dart';
import 'package:kilifi_county_admin/screen/news/edit_article.dart';
import 'package:kilifi_county_admin/screen/news/news_details_screen.dart';

class ArticleTile extends StatelessWidget {
  final int index;
  final String fullName;
  final String image;
  final String profilePic;
  final String title;
  final String article;
  final int views;
  final String username;
  final String postId;
  final Timestamp date;

  const ArticleTile(
      {this.index,
      this.fullName,
      this.image,
      this.profilePic,
      this.title,
      this.article,
      this.views,
      this.username,
      this.postId,
      this.date});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(NewsDetailsScreen.routeName,
            arguments: NewsModel(
                title: title,
                views: views,
                profilePic: profilePic,
                postId: postId,
                index: index,
                image: image,
                fullName: fullName,
                username: username,
                article: article,
                date: date));
      },
      child: Stack(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Text(
                  index < 10 ? '0$index' : '$index',
                  style: font().copyWith(color: Colors.grey, fontSize: 18),
                )),
                SizedBox(width: 20),
                Container(
                  width: 60,
                  height: 50,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(image, fit: BoxFit.fill)),
                ),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(title),
                          ),
                          SizedBox(height: 5),
                          Text(
                            DateFormat('dd/MM/yy').format(date.toDate()),
                            style: font()
                                .copyWith(color: Colors.grey, fontSize: 11),
                          ),
                          SizedBox(height: 15),
                        ],
                      )),
                ),
                if (size.width > 648)
                  Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 8, right: 25),
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                size: 17,
                              ),
                              SizedBox(width: 5),
                              Text(
                                views.toString(),
                                style: font()
                                    .copyWith(fontWeight: FontWeight.w600),
                              )
                            ],
                          )),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
              top: 0,
              right: 5,
              child: PopupMenuButton(
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                      value: 0,
                      child: Text(
                        'Update',
                        style: font(fontSize: 12),
                      )),
                  PopupMenuItem(
                      value: 1,
                      child: Text(
                        'Delete',
                        style: font(fontSize: 12),
                      )),
                ],
                child: Icon(
                  Icons.more_vert,
                  size: 16,
                  color: kPrimary,
                ),
                onSelected: (int i) {
                  if (i == 1) {
                    FirebaseFirestore.instance
                        .collection('admin')
                        .doc('admin_data')
                        .collection('news')
                        .doc(postId)
                        .delete();
                    if (i == 0) {
                      Navigator.of(context).pushNamed(EditArticle.routeName,
                          arguments: NewsModel(
                              title: title,
                              views: views,
                              profilePic: profilePic,
                              postId: postId,
                              index: index,
                              image: image,
                              fullName: fullName,
                              username: username,
                              article: article,
                              date: date));
                    }
                  }
                },
              ))
        ],
      ),
    );
  }
}
