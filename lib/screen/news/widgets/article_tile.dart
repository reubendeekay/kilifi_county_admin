import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/news/add_article.dart';

class ArticleTile extends StatelessWidget {
  final int index;
  final String fullName;
  final List<dynamic> images;
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
      this.images,
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
      onTap: () {},
      child: Container(
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
                  child: Image.network(images.first, fit: BoxFit.fill)),
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
                        style:
                            font().copyWith(color: Colors.grey, fontSize: 11),
                      ),
                      SizedBox(height: 15),
                    ],
                  )),
            ),
            if (size.width > 648)
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Icon(Icons.remove_red_eye_outlined),
                      SizedBox(width: 5),
                      Text(
                        views.toString(),
                        style: font().copyWith(fontWeight: FontWeight.w600),
                      )
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}
