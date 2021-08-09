import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/screen/user_management/widgets/user_list_tile.dart';

class UserManagementSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.29,
      height: double.infinity,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search for a user',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      )),
                ),
              )),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
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
      ),
    );
  }
}
