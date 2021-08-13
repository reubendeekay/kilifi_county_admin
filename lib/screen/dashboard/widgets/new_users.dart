import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/user_management/user_management.dart';

class NewUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            UserManagementCard(),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (ctx, snapshots) {
                  if (snapshots.hasData && !snapshots.hasError) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(UserManagement.routeName),
                      child: TotalUsersTile(
                        number: snapshots.data.docs.length,
                      ),
                    );
                  } else {
                    return TotalUsersTile();
                  }
                }),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 15, bottom: 5),
                  child: Text(
                    'Latest Registered users',
                    style: font()
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .orderBy('joinedAt')
                        .limit(3)
                        .snapshots(),
                    builder: (ctx, snapshots) {
                      if (snapshots.hasData && !snapshots.hasError) {
                        List<DocumentSnapshot> documents = snapshots.data.docs;
                        return Row(
                          children: documents
                              .map((e) => GestureDetector(
                                    onTap: () => Navigator.of(context)
                                        .pushNamed(UserManagement.routeName),
                                    child: NewUserTile(
                                      dateJoined: e['joinedAt'],
                                      fullName: e['fullName'],
                                      imageUrl: e['imageUrl'],
                                      username: e['username'],
                                    ),
                                  ))
                              .toList(),
                        );
                      } else {
                        return Container();
                      }
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TotalUsersTile extends StatelessWidget {
  final String title;
  final int number;
  final String description;
  final String picture;

  const TotalUsersTile(
      {this.title, this.number, this.description, this.picture});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.21,
      constraints: BoxConstraints(minWidth: 150),
      decoration: kBox,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 10),
                child: Text(title == null ? 'Total app Users' : title,
                    style: font()
                        .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Center(
                            child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            number == null ? '23 ^' : '$number ^',
                            style: font().copyWith(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: kPrimary),
                          ),
                        )),
                        Container(
                          width: size.width * 0.1 - 10,
                          margin: EdgeInsets.fromLTRB(20, 10, 5, 20),
                          child: Text(
                              description == null
                                  ? 'These are all users that have registered accounts'
                                  : description,
                              style: font().copyWith(
                                fontSize: 12,
                              )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: Image.asset(
                      picture == null
                          ? 'assets/images/analytics.png'
                          : 'assets/images/$picture',
                      fit: BoxFit.fill,
                    ),
                  ))
                ],
              )
            ],
          )),
    );
  }
}

class NewUserTile extends StatelessWidget {
  final String imageUrl;
  final String fullName;
  final String username;
  final Timestamp dateJoined;

  const NewUserTile(
      {Key key, this.imageUrl, this.fullName, this.username, this.dateJoined})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          spreadRadius: 0.5,
          blurRadius: 40,
        )
      ]),
      width: 130,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(
                height: 1.25,
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  child: Text(fullName,
                      style: font().copyWith(
                        fontWeight: FontWeight.w500,
                      ))),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 1.25),
                  child: Text(
                    '@$username',
                    style: font().copyWith(
                      fontSize: 12,
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: kPrimary,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  margin: EdgeInsets.symmetric(vertical: 1.25),
                  child: Text(
                    DateTime.now().difference(dateJoined.toDate()).inHours > 24
                        ? DateFormat('dd/MM/yyy').format(dateJoined.toDate())
                        : DateFormat.jm().format(dateJoined.toDate()),
                    style: font().copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class UserManagementCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(UserManagement.routeName),
      child: Container(
        width: size.width * 0.28,
        constraints: BoxConstraints(minHeight: 175),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [kPrimary, Colors.yellow[500]]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 0.5,
                blurRadius: 40,
              )
            ]),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Text('User Management',
                  style: font()
                      .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  width: size.width * 0.19 - 10,
                  margin: EdgeInsets.fromLTRB(20, 10, 5, 36),
                  child: Text(
                      'Manage user requests and grant and revoke priviledges such as verification',
                      style: font().copyWith(
                        fontSize: 12,
                      )),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: FaIcon(
                    FontAwesomeIcons.usersCog,
                    size: size.width * 0.05,
                    color: Colors.grey[300],
                  ),
                )
              ],
            ),
          ],
        ),
        // ),
      ),
    );
  }
}
