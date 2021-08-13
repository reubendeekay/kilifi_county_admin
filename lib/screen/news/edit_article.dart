import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/models/news_model.dart';
import 'package:kilifi_county_admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditArticle extends StatelessWidget {
  static const routeName = '/edit-article';

  @override
  Widget build(BuildContext context) {
    final news = ModalRoute.of(context).settings.arguments as NewsModel;
    return Scaffold(
        body: Container(
            color: kBackground.withOpacity(0.5),
            child: WriteExistingArticle(news)));
  }
}

class WriteExistingArticle extends StatefulWidget {
  final NewsModel news;
  WriteExistingArticle(this.news);
  @override
  _WriteExistingArticleState createState() => _WriteExistingArticleState();
}

class _WriteExistingArticleState extends State<WriteExistingArticle> {
  final titleController = TextEditingController();

  final articleController = TextEditingController();

  Uint8List fileBytes;
  String fileName;

  Future<void> _getImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      fileBytes = result.files.first.bytes;
      fileName = result.files.first.name;
      setState(() {});
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

      final data = await FirebaseStorage.instance
          .ref('news/posts/$id')
          .putData(fileBytes);

      final url = await data.ref.getDownloadURL();

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
        'images': url,
        'postId': id,
        'views': 0,
        'title': titleController.text,
        'article': articleController.text,
        'createdAt': Timestamp.now(),
      }, SetOptions(merge: true));
    }

    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      margin: EdgeInsets.symmetric(
        horizontal: size.width > 800 ? size.width * 0.1 : 0,
      ),
      color: Colors.white,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (fileBytes != null)
                  GestureDetector(
                    onTap: () async {
                      await _getImage();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 350,
                      child: fileBytes != null
                          ? Image.memory(
                              fileBytes,
                              fit: BoxFit.fitWidth,
                            )
                          : null,
                    ),
                  ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1,
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 40, horizontal: size.width * 0.03),
                  child: Column(
                    children: [
                      if (fileBytes == null)
                        GestureDetector(
                          onTap: () async {
                            await _getImage();
                          },
                          child: fileBytes == null
                              ? Container(
                                  height: 200,
                                  width: size.width * 0.2,
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.photo),
                                      Text('Add Cover image(s)'),
                                    ],
                                  )),
                                )
                              : null,
                        ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                          child: TextField(
                        maxLines: null,
                        controller: titleController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                          hintStyle: GoogleFonts.tinos(shadows: [
                            Shadow(color: Colors.white, blurRadius: 5)
                          ], fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: TextField(
                        maxLines: null,
                        controller: articleController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Article details',
                          hintStyle: GoogleFonts.tinos(),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
                      shadows: [Shadow(color: Colors.grey)],
                      fontWeight: FontWeight.bold)),
              Spacer(),
              SizedBox(
                width: 150,
                child: RaisedButton(
                    color: kPrimary,
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
                    child: Text('Post')),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
