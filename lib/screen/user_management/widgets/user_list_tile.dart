import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

class UserListTile extends StatelessWidget {
  final String fullName;
  final String username;
  final String imageUrl;
  final String email;
  final String userId;
  final String subCounty;
  final String phoneNumber;
  final String nationalId;
  final String office;
  final bool isAdmin;
  final bool isVerified;

  const UserListTile({
    this.fullName,
    this.username,
    this.imageUrl,
    this.isAdmin,
    this.office,
    this.email,
    this.userId,
    this.subCounty,
    this.phoneNumber,
    this.nationalId,
    this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBox,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Row(
            children: [
              Text(fullName),
              SizedBox(
                width: 5,
              ),
              if (isVerified)
                Icon(
                  Icons.verified,
                  color: Colors.blue,
                  size: 14,
                )
            ],
          ),
          subtitle: Text('@$username'),
          onTap: () {
            showDialog(
                context: context,
                builder: (ctx) => Dialog(
                        child: UserActions(
                      isAdmin: isAdmin,
                      imageUrl: imageUrl,
                      fullName: fullName,
                      nationalId: nationalId,
                      office: office,
                      userId: userId,
                      username: username,
                      phoneNumber: phoneNumber,
                      subCounty: subCounty,
                      email: email,
                      isVerified: isVerified,
                    )));
          },
        ),
      ),
    );
  }
}

class UserActions extends StatefulWidget {
  final String fullName;
  final String username;
  final String imageUrl;
  final String email;
  final String userId;
  final String subCounty;
  final String phoneNumber;
  final String nationalId;
  final bool isAdmin;
  final String office;
  final bool isVerified;

  UserActions(
      {this.fullName,
      this.username,
      this.imageUrl,
      this.email,
      this.office,
      this.userId,
      this.subCounty,
      this.phoneNumber,
      this.nationalId,
      this.isAdmin,
      this.isVerified});
  @override
  UserActionsState createState() => UserActionsState();
}

class UserActionsState extends State<UserActions> {
  final emailController = TextEditingController();
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            width: 350,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    widget.fullName,
                    style: font()
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                details('Username', widget.username),
                if (!isTapped) details('Email address', widget.email),
                if (isTapped)
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(7.5),
                    child: TextField(
                      controller: emailController,
                      decoration:
                          InputDecoration(labelText: 'Update Email Address'),
                    ),
                  ),
                details('National ID', widget.nationalId),
                details('Phone Number', widget.phoneNumber),
                details('Sub County', widget.subCounty),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        onPressed: () {
                          if (emailController.text.isNotEmpty)
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.userId)
                                .update({
                              'email': emailController.text,
                            });
                        },
                        color: kPrimary,
                        child: Text(
                          'Update Details',
                          style: font().copyWith(color: Colors.white),
                        )),
                    RaisedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .update({
                            'isVerified': widget.isVerified ? false : true,
                          });
                        },
                        color: widget.isVerified ? Colors.red : Colors.green,
                        child: Text(!widget.isVerified ? 'Verify' : 'Unverify',
                            style: font().copyWith(color: Colors.white))),
                    RaisedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .update({
                            'isAdmin': widget.isAdmin ? false : true,
                            'office': widget.office == null
                                ? 'Unassigned'
                                : widget.office
                          });
                        },
                        color: widget.isAdmin ? Colors.red : Colors.green,
                        child: Text(
                            widget.isAdmin ? 'Remove Admin' : 'Make Admin',
                            style: font().copyWith(color: Colors.white))),
                  ],
                )
              ],
            ),
          ),
          Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isTapped = !isTapped;
                    });
                  },
                  icon: Icon(Icons.edit)))
        ],
      ),
    );
  }

  Widget details(String title, String data) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(7.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: font().copyWith(color: Colors.grey),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                data,
                textAlign: TextAlign.start,
                style: font().copyWith(fontWeight: FontWeight.w500),
              ),
            )
          ],
        ));
  }
}
