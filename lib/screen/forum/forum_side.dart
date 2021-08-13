import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as fb;

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/forum/dialogs.dart';

class ForumSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.2,
      constraints: BoxConstraints(minWidth: 250),
      child: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          PostToGallery(),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('admin')
                .doc('admin_data')
                .collection('gallery')
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                List<DocumentSnapshot> documents = snapshot.data.docs;

                return Expanded(
                    child: ListView(
                        children: documents
                            .map((e) => GalleryItem(
                                  caption: e['caption'],
                                  imgList: e['galleryPics'],
                                ))
                            .toList()));
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}

class PostToGallery extends StatefulWidget {
  @override
  _PostToGalleryState createState() => _PostToGalleryState();
}

class _PostToGalleryState extends State<PostToGallery> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width > 648 ? size.width * 0.19 : double.infinity,
      constraints: BoxConstraints(minWidth: 230),
      margin: size.width > 648 ? EdgeInsets.symmetric(horizontal: 30) : null,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: kBackground,
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 10, 10, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Text(
                  'County Gallery',
                  style: font().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    'Add a picture to the county gallery collection to showcase latest events or developments',
                    style: font().copyWith(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: () => addGallery(context),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'Add a poster',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: kPrimary,
                )
              ],
            ),
          )),
    );
  }

  Future<void> addGallery(BuildContext context) {
    return showAlignedDialog(
        followerAnchor: Alignment.bottomLeft,
        avoidOverflow: true,
        context: context,
        builder: (context) => GalleryDialog());
  }
}

class GalleryItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 230,
        child: ListView(
          children: [
            GalleryItem(),
            GalleryItem(),
            GalleryItem(),
          ],
        ),
      ),
    );
  }
}

class GalleryItem extends StatefulWidget {
  final List<dynamic> imgList;
  final String caption;
  GalleryItem({this.imgList, this.caption});
  @override
  State<StatefulWidget> createState() {
    return _GalleryItemState();
  }
}

class _GalleryItemState extends State<GalleryItem> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<Widget> imageSliders;

  @override
  void initState() {
    imageSliders = widget.imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          item,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      ],
                    )),
              ),
            ))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Container(
            height: size.width > 648 ? 200 : 400,
            child: Stack(children: [
              CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    height: size.width > 648 ? 200 : 400,
                    disableCenter: true,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Align(
                // bottom: 5,
                alignment: Alignment(1, 1),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 6.0,
                        height: 6.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            child: Container(
              width: size.width > 648 ? 220 : size.width - 10,
              color: Colors.black26,
              padding: EdgeInsets.all(5),
              child: Text(
                widget.caption,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    size: 16,
                    color: Colors.red,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
