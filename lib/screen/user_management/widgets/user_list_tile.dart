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
  final bool isAdmin;
  final bool isVerified;
  final String latestMessage;

  const UserListTile(
      {this.fullName,
      this.username,
      this.imageUrl,
      this.isAdmin,
      this.email,
      this.userId,
      this.subCounty,
      this.phoneNumber,
      this.nationalId,
      this.isVerified,
      this.latestMessage});

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
            showDialog(context: context, builder: (ctx) => UserActions());
          },
        ),
      ),
    );
  }
}

class UserActions extends StatefulWidget {
  @override
  UserActionsState createState() => UserActionsState();
}

class UserActionsState extends State<UserActions> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(20),
        width: 400,
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
            ),
            SizedBox(
              height: 10,
            ),
            details(),
          ],
        ),
      ),
    );
  }

  Widget details() {
    return Container(
        child: Row(
      children: [
        Container(
          width: 100,
          child: Text('Full Name'),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          child: Text('Reuben Jefwa'),
        )
      ],
    ));
  }
}
