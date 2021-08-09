import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/user_management/user_management.dart';

class NewUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          UserManagementCard(),
          TotalUsersTile(),
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
              Row(
                children: [
                  NewUserTile(),
                  NewUserTile(),
                  NewUserTile(),
                ],
              ),
            ],
          )
        ],
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
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              SizedBox(
                height: 1.25,
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  child: Text('Reuben Jefwa',
                      style: font().copyWith(
                        fontWeight: FontWeight.w500,
                      ))),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 1.25),
                  child: Text(
                    '@deekay',
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
                    '11/12/2021',
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
