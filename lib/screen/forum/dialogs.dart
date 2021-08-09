import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

class JobDialog extends StatefulWidget {
  @override
  _JobDialogState createState() => _JobDialogState();
}

class _JobDialogState extends State<JobDialog> {
  List<html.File> imageFiles = [];

  final jobDescriptionController = TextEditingController();
  final jobLinkController = TextEditingController();
  final jobTitleController = TextEditingController();

  void _getImage() async {
    List<html.File> images =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.file);

    if (imageFiles != null) {
      imageFiles = images;
    }
  }

  Future<void> sendData() async {
    final user = Provider.of<UsersProvider>(context, listen: false).user;
    final jobId = FirebaseFirestore.instance
        .collection('admin')
        .doc('adminData')
        .collection('jobs')
        .doc()
        .id;
    List<String> urls = [];

    Future.forEach(imageFiles, (element) async {
      await fb
          .storage()
          .refFromURL('gs://kilifi-county-ba077.appspot.com')
          .child('jobData/$jobId/${element.name}')
          .put(element)
          .future;
    }).then((_) async {
      Future.forEach(imageFiles, (element) async {
        await fb
            .storage()
            .refFromURL('gs://kilifi-county-ba077.appspot.com/')
            .child('jobData/$jobId/${element.name}')
            .getDownloadURL()
            .then((value) => urls.add(value.toString()));
      }).then((_) async => await FirebaseFirestore.instance
              .collection('admin')
              .doc('admin_data')
              .collection('jobs')
              .doc(jobId)
              .set({
            'userId': user.userId,
            'fullName': user.fullName,
            'username': user.username,
            'imageUrl': user.imageUrl,
            'title': jobTitleController.text,
            'jobId': jobId,
            'postPics': FieldValue.arrayUnion(urls),
            'description': jobDescriptionController.text,
            'link': jobLinkController.text,
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(20),
        child: Container(
          width: 400,
          height: 500,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    width: 210,
                    height: 90,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: imageFiles.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image),
                              Text('Pick an image')
                            ],
                          )
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeIn,
                            child: SizedBox(
                              width: 500,
                              height: 200,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageFiles == null
                                      ? 0
                                      : imageFiles.length,
                                  itemBuilder: (context, index) =>
                                      Text('Image ${index + 1}')),
                            ),
                          ),
                  ),
                ),
                Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: jobTitleController,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: 'Title', border: InputBorder.none),
                        ))),
                Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: jobDescriptionController,
                          maxLines: 12,
                          decoration: InputDecoration(
                              hintText: 'Add Details',
                              border: InputBorder.none),
                        ))),
                Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: jobLinkController,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: 'Application/Job link if any',
                              border: InputBorder.none),
                        ))),
                Spacer(),
                RaisedButton(
                  onPressed:
                      imageFiles.isNotEmpty ? () async => sendData() : null,
                  child: Text(
                    'Post',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: kPrimary,
                )
              ],
            ),
          ),
        ));
  }
}

class TweetDialog extends StatefulWidget {
  @override
  _TweetDialogState createState() => _TweetDialogState();
}

class _TweetDialogState extends State<TweetDialog> {
  List<html.File> imageFiles = [];

  final descriptionController = TextEditingController();

  void _getImage() async {
    List<html.File> images =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.file);

    if (imageFiles != null) {
      imageFiles = images;
    }
  }

  final id = FirebaseFirestore.instance
      .collection('forum')
      .doc('posts')
      .collection(FirebaseAuth.instance.currentUser.uid)
      .doc()
      .id;

  Future<void> sendData() async {
    final user = Provider.of<UsersProvider>(context, listen: false).user;

    List<String> urls = [];

    Future.forEach(imageFiles, (element) async {
      await fb
          .storage()
          .refFromURL('gs://kilifi-county-ba077.appspot.com')
          .child('forum/posts/$id')
          .put(element)
          .future;
    }).then((_) async {
      Future.forEach(imageFiles, (element) async {
        await fb
            .storage()
            .refFromURL('gs://kilifi-county-ba077.appspot.com/')
            .child('forum/posts/$id')
            .getDownloadURL()
            .then((value) => urls.add(value.toString()));
      }).then((_) async {
        await FirebaseFirestore.instance.collection('posts').doc(id).set({
          'userId': user.userId,
          'fullName': user.fullName,
          'username': user.username,
          'profilePic': user.imageUrl,
          'imageUrl': urls.first,
          'postId': id,
          'description': descriptionController.text,
          'comments': [],
          'isVerified': user.isVerified,
          'likes': [],
          'createdAt': Timestamp.now(),
        }, SetOptions(merge: true));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.all(20),
        child: Container(
          width: 400,
          height: 450,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    width: 300,
                    height: 250,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: imageFiles == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image),
                              Text('Pick an image')
                            ],
                          )
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeIn,
                            child: SizedBox(
                              width: 500,
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageFiles == null
                                      ? 0
                                      : imageFiles.length,
                                  itemBuilder: (context, index) =>
                                      Text('Image ${index + 1}')),
                            ),
                          ),
                  ),
                ),
                Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: descriptionController,
                          maxLines: 6,
                          decoration: InputDecoration(
                              hintText: 'Add a description',
                              border: InputBorder.none),
                        ))),
                Spacer(),
                RaisedButton(
                  onPressed:
                      imageFiles != null ? () async => await sendData() : null,
                  child: Text(
                    'Post',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: kPrimary,
                )
              ],
            ),
          ),
        ));
  }
}

class GalleryDialog extends StatefulWidget {
  @override
  _GalleryDialogState createState() => _GalleryDialogState();
}

class _GalleryDialogState extends State<GalleryDialog> {
  List<html.File> imageFiles = [];

  final descriptionController = TextEditingController();

  void _getImage() async {
    List<html.File> images =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.file);

    if (imageFiles != null) {
      imageFiles = images;
    }
  }

  Future<void> sendData() async {
    final postId = FirebaseFirestore.instance
        .collection('admin')
        .doc('adminData')
        .collection('gallery')
        .doc()
        .id;
    List<String> urls = [];

    Future.forEach(imageFiles, (element) async {
      await fb
          .storage()
          .refFromURL('gs://kilifi-county-ba077.appspot.com')
          .child('gallery/$postId/${element.name}')
          .put(element)
          .future;
    }).then((_) async {
      Future.forEach(imageFiles, (element) async {
        await fb
            .storage()
            .refFromURL('gs://kilifi-county-ba077.appspot.com/')
            .child('gallery/$postId/${element.name}')
            .getDownloadURL()
            .then((value) => urls.add(value.toString()));
      }).then((_) async => await FirebaseFirestore.instance
              .collection('admin')
              .doc('admin_data')
              .collection('gallery')
              .doc(postId)
              .set({
            'postId': postId,
            'galleryPics': FieldValue.arrayUnion(urls),
            'caption': descriptionController.text,
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.all(20),
      child: Container(
        width: 300,
        height: 300,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  width: 230,
                  height: 150,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: imageFiles.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.image), Text('Pick an image')],
                        )
                      : Text('${imageFiles.length} images'),
                ),
              ),
              Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                            hintText: 'Add a caption',
                            border: InputBorder.none),
                      ))),
              Spacer(),
              RaisedButton(
                onPressed:
                    imageFiles != null ? () async => await sendData() : null,
                child: Text(
                  'Post',
                  style: TextStyle(color: Colors.white),
                ),
                color: kPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
