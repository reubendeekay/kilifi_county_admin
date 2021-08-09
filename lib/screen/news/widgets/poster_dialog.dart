import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase/firebase.dart' as fb;

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PosterDialog extends StatefulWidget {
  @override
  _PosterDialogState createState() => _PosterDialogState();
}

class _PosterDialogState extends State<PosterDialog> {
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
    final user = Provider.of<UsersProvider>(context, listen: false).user;
    final postId = FirebaseFirestore.instance
        .collection('admin')
        .doc('adminData')
        .collection('posters')
        .doc()
        .id;
    List<String> urls = [];

    Future.forEach(imageFiles, (element) async {
      await fb
          .storage()
          .refFromURL('gs://kilifi-county-ba077.appspot.com')
          .child('posterData/$postId/${element.name}')
          .put(element)
          .future;
    }).then((_) async {
      Future.forEach(imageFiles, (element) async {
        await fb
            .storage()
            .refFromURL('gs://kilifi-county-ba077.appspot.com/')
            .child('posterData/$postId/${element.name}')
            .getDownloadURL()
            .then((value) => urls.add(value.toString()));
      }).then((_) async => await FirebaseFirestore.instance
              .collection('admin')
              .doc('admin_data')
              .collection('posters')
              .doc(postId)
              .set({
            'userId': user.userId,
            'fullName': user.fullName,
            'username': user.username,
            'imageUrl': user.imageUrl,
            'postId': postId,
            'postPics': FieldValue.arrayUnion(urls),
            'description': descriptionController.text,
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
                onTap: () => _getImage(),
                child: Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: imageFiles == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.image), Text('Pick an image')],
                        )
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeIn,
                          child: SizedBox(
                            width: 500,
                            height: 200,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    imageFiles == null ? 0 : imageFiles.length,
                                itemBuilder: (context, index) =>
                                    Center(child: Text('Image ${index + 1}'))),
                          ),
                        ),
                ),
              ),
              Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        maxLines: 4,
                        controller: descriptionController,
                        decoration: InputDecoration(
                            hintText: 'Add a description',
                            border: InputBorder.none),
                      ))),
              Spacer(),
              RaisedButton(
                onPressed: imageFiles != null
                    ? () async {
                        await sendData();
                        print("Successful");
                      }
                    : null,
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
