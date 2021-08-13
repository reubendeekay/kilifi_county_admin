import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/user_management/widgets/user_list_tile.dart';

class AddAdminCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.3,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Make User an Admin',
                  style: font()
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: size.width * 0.22,
                child: Text(
                    'Grant a specific user admin status. Admins are only authorized staff and making a user an admin'),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                                child: AdminExisting(),
                              ));
                    },
                    color: kPrimary,
                    child: Text(
                      'Existing user',
                      style: font().copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.01,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                                child: CreateAdmin(),
                              ));
                    },
                    color: kPrimary,
                    child: Text(
                      'Create Admin Account',
                      style: font().copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: Image.asset(
                'assets/images/admin_cat.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminExisting extends StatefulWidget {
  @override
  AdminExistingState createState() => AdminExistingState();
}

class AdminExistingState extends State<AdminExisting> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          width: 350,
          child: ListView(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search for a user',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          )),
                    ),
                  )),
              if (searchController.text.isNotEmpty)
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('fullName',
                            isGreaterThanOrEqualTo: toBeginningOfSentenceCase(
                                searchController.text))
                        .where('fullName',
                            isLessThan: toBeginningOfSentenceCase(
                                searchController.text + 'z'))
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        List<DocumentSnapshot> documents = snapshot.data.docs;

                        return ListView(
                          shrinkWrap: true,
                          children: documents
                              .map((e) => UserListTile(
                                  fullName: e['fullName'],
                                  imageUrl: e['imageUrl'],
                                  username: e['username'],
                                  email: e['email'],
                                  isVerified: e['isVerified'],
                                  nationalId: e['nationalId'],
                                  phoneNumber: e['phoneNumber'],
                                  subCounty: e['subCounty'],
                                  userId: e['userId']))
                              .toList(),
                        );
                      } else {
                        return Container();
                      }
                    }),
            ],
          )),
    );
  }
}

class CreateAdmin extends StatefulWidget {
  @override
  _CreateAdminState createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String username = '';
  String email = '';
  String password = '';
  String idNo = '';
  String phoneNumber = '';
  String location = '';
  Uint8List fileBytes;
  String fileName;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(20),
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    child: Text(
                  'Create Admin Account Form',
                  style: font().copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    await getImage();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: fileBytes == null
                        ? Icon(
                            Icons.person,
                            size: 40,
                          )
                        : null,
                    backgroundImage:
                        fileBytes != null ? MemoryImage(fileBytes) : null,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      'Account Credentials',
                      style: font().copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                textField('Email address', email),
                textField('Password', password),
                SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      'Personal Information',
                      style: font().copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                textField('Full name', fullName),
                textField('Username', username),
                textField('National ID', idNo),
                textField('Phone number', phoneNumber),
                textField('Sub County', location),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 280,
                  child: RaisedButton(
                    color: kPrimary,
                    onPressed: () async {
                      if (fileBytes != null) {
                        await _uploadDoc();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Please pick a profile picture for the user')));
                      }
                    },
                    child: Text(
                      'Submit',
                      style: font().copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(String title, String variable) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: title,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Do not leave empty fields';
              }
              return null;
            },
            onChanged: (val) {
              setState(() {
                variable = val;
              });
            },
          ),
        ));
  }

  Future<void> getImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      fileBytes = result.files.first.bytes;
      fileName = result.files.first.name;
      setState(() {});
    }
  }

  Future<void> _uploadDoc() async {
    if (_formKey.currentState.validate()) {
      final data = await FirebaseStorage.instance
          .ref('user_profile_images/admins/$fileName')
          .putData(fileBytes);

      final url = await data.ref.getDownloadURL();
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user.uid)
          .set({
        'userId': user.user.uid,
        'email': email,
        'username': username,
        'imageUrl': url,
        'fullName': fullName,
        'nationalId': idNo,
        'phoneNumber': phoneNumber,
        'subCounty': location,
        'joinedAt': Timestamp.now(),
        'isVerified': false,
        'isAdmin': true,
      }, SetOptions(merge: true));

      Navigator.of(context).pop();
    }
  }
}
