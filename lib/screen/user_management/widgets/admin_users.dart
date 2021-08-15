import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

class AdminUsers extends StatefulWidget {
  @override
  _AdminUsersState createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.31,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Admin Users',
              style: font().copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              width: size.width * 0.26,
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
          searchController.text.isEmpty
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('isAdmin', isEqualTo: true)
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData && !snapshot.hasError) {
                      List<DocumentSnapshot> documents = snapshot.data.docs;

                      return ListView(
                        shrinkWrap: true,
                        children: documents
                            .map((e) => AdminListTile(
                                fullName: e['fullName'],
                                imageUrl: e['imageUrl'],
                                office: e['office'],
                                isAdmin: e['isAdmin'],
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
                  })
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      // .where('isAdmin', isEqualTo: true)
                      .where('fullName',
                          isGreaterThanOrEqualTo:
                              toBeginningOfSentenceCase(searchController.text))
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
                            .map((e) => AdminListTile(
                                fullName: e['fullName'],
                                imageUrl: e['imageUrl'],
                                office: e['office'],
                                isAdmin: e['isAdmin'],
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

class AdminListTile extends StatelessWidget {
  final String fullName;
  final String username;
  final String imageUrl;
  final String email;
  final String office;
  final String userId;
  final String subCounty;
  final String phoneNumber;
  final String nationalId;
  final bool isAdmin;
  final bool isVerified;

  const AdminListTile({
    this.fullName,
    this.office,
    this.username,
    this.imageUrl,
    this.email,
    this.userId,
    this.subCounty,
    this.phoneNumber,
    this.nationalId,
    this.isAdmin,
    this.isVerified,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBox,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: CachedNetworkImageProvider(imageUrl),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2.5),
                    child: Row(
                      children: [
                        Text(
                          fullName,
                          style: font().copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        if (isVerified)
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 12,
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2.5),
                    child: Text(
                      '@$username',
                      style: font().copyWith(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2.5),
                    child: Text(
                      office,
                      style: font().copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              Spacer(),
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                itemBuilder: (
                  ctx,
                ) =>
                    [
                  PopupMenuItem(
                    value: 0,
                    height: 30,
                    child: Text('Update'),
                    textStyle: TextStyle(fontSize: 13),
                  ),
                  PopupMenuItem(
                    value: 1,
                    height: 30,
                    child: Text('Demote'),
                    textStyle: TextStyle(fontSize: 13),
                  ),
                ],
                onSelected: (i) {
                  if (i == 1) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({
                      'isAdmin': false,
                      'office': null,
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
