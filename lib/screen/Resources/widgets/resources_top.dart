import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/Resources/widgets/add_resource_dialog.dart';

class ResourcesTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(width: size.width * 0.45),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: RaisedButton(
                onPressed: () async {
                  await addDocument(context);
                },
                color: kBackground.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'Upload document',
                  style: font().copyWith(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Container(
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kPrimary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.45,
                  child: Text(
                    'Upload official documents and offial news letters to the Public. Users will be able to download the documents to their devices. Ensure each document is in the right category and has a descriptive name',
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    style: font().copyWith(fontSize: 18),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                FaIcon(
                  FontAwesomeIcons.solidFolder,
                  color: kBackground,
                  size: size.width * 0.09,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> addDocument(BuildContext context) {
    return showAlignedDialog(
        followerAnchor: Alignment.bottomLeft,
        avoidOverflow: true,
        context: context,
        builder: (context) => AddResourceDialog());
  }
}
