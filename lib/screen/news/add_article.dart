import 'dart:html' as html;
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddArticle extends StatelessWidget {
  static const routeName = '/add-article';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: kBackground.withOpacity(0.5), child: WriteArticle()));
  }
}

class WriteArticle extends StatefulWidget {
  @override
  _WriteArticleState createState() => _WriteArticleState();
}

class _WriteArticleState extends State<WriteArticle> {
  final titleController = TextEditingController();

  final articleController = TextEditingController();

  List<html.File> imageFiles = [];

  void _getImage() async {
    List<html.File> images =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.file);

    if (images != null) {
      imageFiles = images;
    }
  }

  final id = FirebaseFirestore.instance
      .collection('admin')
      .doc('admin_data')
      .collection('news')
      .doc()
      .id;

  @override
  Widget build(BuildContext context) {
    Future<void> sendData() async {
      final user = Provider.of<UsersProvider>(context, listen: false).user;

      List<String> urls = [];

      Future.forEach(imageFiles, (element) async {
        await fb
            .storage()
            .refFromURL('gs://kilifi-county-ba077.appspot.com')
            .child('news/posts/$id')
            .put(element)
            .future;
      }).then((_) async {
        Future.forEach(imageFiles, (element) async {
          await fb
              .storage()
              .refFromURL('gs://kilifi-county-ba077.appspot.com/')
              .child('news/posts/$id')
              .getDownloadURL()
              .then((value) => urls.add(value.toString()));
        }).then((_) async {
          await FirebaseFirestore.instance
              .collection('admin')
              .doc('admin_data')
              .collection('news')
              .doc(id)
              .set({
            'userId': user.userId,
            'fullName': user.fullName,
            'username': user.username,
            'profilePic': user.imageUrl,
            'images': FieldValue.arrayUnion(urls),
            'postId': id,
            'views': 0,
            'title': titleController.text,
            'article': articleController.text,
            'createdAt': Timestamp.now(),
          }, SetOptions(merge: true));
        });
      });
    }

    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.1,
      ),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text('Write an article',
                      style: font().copyWith(
                          fontSize: 24,
                          color: kBackground,
                          fontWeight: FontWeight.bold)),
                  Spacer(),
                  ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isNotEmpty &&
                            articleController.text.isNotEmpty) {
                          await sendData();
                          print('successful');
                          Navigator.of(context).pop();
                        } else {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    content: Text(
                                        'Fill all required fields:\n\t Image(s)\n\t Title \n\t Article Content'),
                                    title: Text('A required Field is empty'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('Ok'))
                                    ],
                                  ));
                        }
                      },
                      child: Text('Post'))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 40, horizontal: size.width * 0.03),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _getImage,
                          child: Container(
                            height: 200,
                            width: size.width * 0.2,
                            child: Center(
                                child: Text(imageFiles.isEmpty
                                    ? 'Add Cover image(s)'
                                    : '${imageFiles.length} images')),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        Expanded(
                          child: Container(
                              child: AutoSizeTextField(
                            maxLines: null,
                            controller: titleController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title',
                              hintStyle: GoogleFonts.tinos(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SingleChildScrollView(
                      child: Container(
                          child: AutoSizeTextField(
                        maxLines: null,
                        controller: articleController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Article details',
                          hintStyle: GoogleFonts.tinos(),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
