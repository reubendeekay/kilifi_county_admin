import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as fb;

import 'package:flutter/material.dart';

import 'package:kilifi_county_admin/helpers/constants.dart';

import 'package:dashed_circle/dashed_circle.dart';
import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/screen/news/widgets/poster_dialog.dart';

class PostersContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        child: Responsive(
            desktop: Container(
              width: size.width * 0.24,
              child: Column(
                children: [AddPosterTile(), getStream(isRow: false)],
              ),
            ),
            tab: Container(
              width: size.width * 0.24,
              child: Column(
                children: [AddPosterTile(), getStream(isRow: false)],
              ),
            ),
            mobile: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [AddPosterTile(), getStream(isRow: true)],
                ),
              ),
            )));
  }

  Widget getStream({bool isRow}) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('admin')
            .doc('admin_data')
            .collection('posters')
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            List<DocumentSnapshot> documents = snapshot.data.docs;

            return Expanded(
              child: ListView(
                  scrollDirection: isRow ? Axis.horizontal : Axis.vertical,
                  children: documents
                      .map((e) => PosterTile(
                          description: e['description'],
                          image: e['postPics'][0],
                          name: e['fullName'],
                          posterId: e['postId'],
                          profilePic: e['imageUrl'],
                          userName: e['username'],
                          date: e['createdAt']))
                      .toList()),
            );
          } else {
            return Container();
          }
        });
  }
}

class AddPosterTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: kSecondary.withOpacity(0.6),
        child: Padding(
          padding: EdgeInsets.fromLTRB(25, 10, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Text(
                'Quick Poster',
                style:
                    font().copyWith(fontSize: 18, fontWeight: FontWeight.w800),
              )),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Add a post which will look like an Instagram story in the user app',
                  style: font().copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(height: 10),
              RaisedButton(
                onPressed: () async => await addPoster(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'Add a poster',
                  style: TextStyle(color: Colors.white),
                ),
                color: kBackground,
              )
            ],
          ),
        ));
  }

  Future<void> addPoster(BuildContext context) {
    return showAlignedDialog(
        followerAnchor: Alignment.bottomLeft,
        avoidOverflow: true,
        context: context,
        builder: (context) => PosterDialog());
  }
}

class PosterTile extends StatefulWidget {
  final String image;
  final String name;
  final String profilePic;
  final String userName;
  final String description;
  final String posterId;
  final Timestamp date;

  const PosterTile(
      {this.image,
      this.posterId,
      this.date,
      this.name,
      this.profilePic,
      this.userName,
      this.description});

  @override
  _PosterTileState createState() => _PosterTileState();
}

class _PosterTileState extends State<PosterTile>
    with SingleTickerProviderStateMixin {
  Animation gap;
  Animation<double> base;
  Animation<double> reverse;
  AnimationController controller;

  /// Init
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 3.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  /// Dispose
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 8, bottom: 10, top: 2),
                child: RotationTransition(
                  turns: base,
                  child: DashedCircle(
                    gapSize: gap.value,
                    dashes: 30,
                    color: Colors.deepOrange,
                    child: RotationTransition(
                        turns: reverse,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(widget.image),
                        )),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Text(
                      widget.description,
                      softWrap: true,
                    )),
                    Container(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 6,
                            backgroundImage: NetworkImage(widget.profilePic),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Container(
                            child: Text(
                              widget.name,
                              style: font(color: Colors.grey, fontSize: 10),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
              top: 2,
              right: 6,
              child: PopupMenuButton(
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                      value: 0,
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
                onSelected: (i) {
                  if (i == 0) {
                    FirebaseFirestore.instance
                        .collection('admin')
                        .doc('admin_data')
                        .collection('posters')
                        .doc(widget.posterId)
                        .delete();
                  }
                },
              ))
        ],
      ),
    );
  }
}
