import 'dart:io';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/forum/dialogs.dart';

class ForumContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SendOpportunity(),
                  SizedBox(
                    width: size.width * 0.013,
                  ),
                  SendTweet(),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                    child: Text(
                  'Latest Posts',
                  style: GoogleFonts.tinos(
                      fontWeight: FontWeight.w800, fontSize: 24),
                )),
              ),
              PinnedPosts(),
            ],
          ),
        ),
      ),
    );
  }
}

class SendTweet extends StatefulWidget {
  @override
  _SendTweetState createState() => _SendTweetState();
}

class _SendTweetState extends State<SendTweet> {
  File _image;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width > 648 ? size.width * 0.2 : double.infinity,
      margin: EdgeInsets.all(15),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Post to Users',
                      style: font()
                          .copyWith(fontWeight: FontWeight.w800, fontSize: 19),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'The post will be pinned for 24 hours for all users to see',
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    )),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: kPrimary,
                    onPressed: () => addTweet(context),
                    child: Text('Post',
                        style: font().copyWith(color: Colors.white)))
              ],
            ),
          )),
    );
  }

  Future<void> addTweet(BuildContext context) {
    return showAlignedDialog(
        followerAnchor: Alignment.bottomCenter,
        avoidOverflow: true,
        context: context,
        builder: (context) => TweetDialog());
  }
}

class SendOpportunity extends StatefulWidget {
  @override
  _SendOpportunityState createState() => _SendOpportunityState();
}

class _SendOpportunityState extends State<SendOpportunity> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width > 648 ? size.width * 0.2 : double.infinity,
      constraints: BoxConstraints(minWidth: 200),
      margin: EdgeInsets.all(15),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: kPrimary,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Job/Internship Opportunity',
                      style: font()
                          .copyWith(fontWeight: FontWeight.w800, fontSize: 19),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Give information to the public about any job or internship opportunity available',
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    )),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: kSecondary,
                    onPressed: () => addOpportunity(context),
                    child: Text('Send',
                        style: font().copyWith(color: Colors.white)))
              ],
            ),
          )),
    );
  }

  Future<void> addOpportunity(BuildContext context) {
    return showAlignedDialog(
        followerAnchor: Alignment.bottomRight,
        targetAnchor: Alignment.bottomRight,
        avoidOverflow: true,
        context: context,
        builder: (context) => JobDialog());
  }
}

class PinnedPosts extends StatelessWidget {
  final uid = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('imageUrl', isGreaterThanOrEqualTo: "")
              .limit(5)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              List<DocumentSnapshot> documents = snapshot.data.docs;

              return Container(
                height: size.width > 648 ? 270 : size.width + 50,
                child: Center(
                  child: ListView(
                    scrollDirection:
                        size.width > 648 ? Axis.horizontal : Axis.vertical,
                    physics: size.width > 648
                        ? ScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    children: documents
                        .map((e) => post(
                            size: size,
                            imageUrl: e['profilePic'],
                            userId: e['userId'],
                            username: e['username'],
                            fullname: e['fullName'],
                            postUrl: e['imageUrl']))
                        .toList(),
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  Widget post(
      {String username,
      String userId,
      String imageUrl,
      Size size,
      String postUrl,
      String fullname}) {
    return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            spreadRadius: 0.5,
            blurRadius: 30,
          )
        ]),
        width: 210,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullname,
                                style: font()
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text('@$username',
                                  style: font().copyWith(
                                      fontSize: 12, color: Colors.grey))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      height: size.width > 648 ? 200 : size.width - 20,
                      child: ClipRRect(
                          child: Image.network(postUrl, fit: BoxFit.fill))),
                ],
              ),
              Positioned(
                right: 5,
                top: 2,
                child: Icon(
                  Icons.cancel,
                  size: 25,
                  color: kPrimary,
                ),
              )
            ],
          ),
        ));
  }
}
