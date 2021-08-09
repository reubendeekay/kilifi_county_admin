import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

class AddResourceDialog extends StatefulWidget {
  @override
  _AddResourceDialogState createState() => _AddResourceDialogState();
}

class _AddResourceDialogState extends State<AddResourceDialog> {
  final docNameController = TextEditingController();
  Uint8List fileBytes;
  String fileName;
  String defaultValue = 'Downloads';
  List<String> dropDownItems = [
    'Downloads',
    'Departments',
    'Budget&Finances',
    'Perfomance Contract Docs'
  ];

  Future<void> getFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      fileBytes = result.files.first.bytes;
      fileName = result.files.first.name;
      setState(() {});
    }
  }

  Future<void> _uploadDoc() async {
    final data = await FirebaseStorage.instance
        .ref('documents/$defaultValue/$fileName')
        .putData(fileBytes);

    final url = await data.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('admin')
        .doc('documents')
        .collection(defaultValue)
        .doc(docNameController.text)
        .set({
      'docName': docNameController.text,
      'category': defaultValue,
      'url': url,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        width: 300,
        height: 350,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  RaisedButton(
                    onPressed: () async {
                      await getFile();
                    },
                    color: kPrimary,
                    child: Text(
                      'Insert File',
                      style: font().copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(fileName != null ? '$fileName' : '')
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: docNameController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter the document name'),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text('Category'),
              ),
              DropdownButton(
                  onChanged: (value) {
                    setState(() {
                      defaultValue = value;
                    });
                  },
                  hint: Text('Pick category of document'),
                  items: dropDownItems
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(e))))
                      .toList()),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 100,
                child: RaisedButton(
                    color: kBackground,
                    child: Text('Upload',
                        style: font().copyWith(
                          color: Colors.white,
                        )),
                    onPressed: () async {
                      if (docNameController.text.isNotEmpty &&
                          fileBytes != null) {
                        await _uploadDoc();
                        Navigator.of(context).pop();
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
