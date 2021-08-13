import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
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

  NewsModel(
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
}
