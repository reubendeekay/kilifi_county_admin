import 'dart:io';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/cache_image.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/helpers/custom_widgets/bar_chart.dart';
import 'package:kilifi_county_admin/helpers/custom_widgets/line_chart.dart';
import 'package:kilifi_county_admin/helpers/custom_widgets/radar_chart.dart';
import 'package:kilifi_county_admin/screen/forum/dialogs.dart';
import 'package:kilifi_county_admin/screen/forum/widgets/forum_posts.dart';

class ForumContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 350,
                margin: EdgeInsets.all(25),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BarChartSample2(),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      LineChartSample2(),
                      RadarChartSample1(),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Job/Internship Opportunities',
                  style: font(fontWeight: FontWeight.w800, fontSize: 24),
                )),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    JobOpportunitiesPosts(
                      isVert: false,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                  child: Text(
                'Forum Posts',
                style: font(fontWeight: FontWeight.w800, fontSize: 24),
              )),
              SizedBox(
                height: 15,
              ),
              ForumPosts()
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
    return showDialog(
        context: context, builder: (ctx) => Dialog(child: JobDialog()));
  }
}

class JobOpportunitiesPosts extends StatelessWidget {
  final bool isVert;
  JobOpportunitiesPosts({this.isVert});
  final uid = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('admin')
              .doc('admin_data')
              .collection('jobs')
              .orderBy('createdAt')
              .limit(4)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              List<DocumentSnapshot> documents = snapshot.data.docs;

              return Container(
                height: 310,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: isVert ? Axis.vertical : Axis.horizontal,
                  children: documents
                      .map((e) => post(
                          size: size,
                          link: e['link'],
                          title: e['title'],
                          profile: e['imageUrl'],
                          description: e['description'],
                          imageUrl: e['postPics'],
                          views: e['views'],
                          userId: e['userId'],
                          username: e['username'],
                          fullname: e['fullName'],
                          jobId: e['jobId']))
                      .toList(),
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
      String title,
      int views,
      final String link,
      String profile,
      final String jobId,
      String description,
      String imageUrl,
      Size size,
      String fullname}) {
    return Container(
      width: 300,
      decoration: kBox,
      child: Stack(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  child: cacheImage(
                    url: imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        width: 260,
                        child: Text(
                          title,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style:
                              font(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: 270,
                        child: Text(
                          description,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye_outlined,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '$views',
                            style: font(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: PopupMenuButton(
              itemBuilder: (ctx) => [
                PopupMenuItem(
                    value: 0,
                    child: Text(
                      'Delete',
                      style: font(fontSize: 12),
                    )),
                PopupMenuItem(
                    value: 1,
                    child: Text(
                      'Update',
                      style: font(fontSize: 12),
                    )),
              ],
              child: Icon(
                Icons.more_vert,
                color: kPrimary,
              ),
              onSelected: (i) {
                if (i == 0) {
                  FirebaseFirestore.instance
                      .collection('admin')
                      .doc('admin_data')
                      .collection('jobs')
                      .doc(jobId)
                      .delete();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
