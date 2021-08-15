import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

class AppointmentCard extends StatelessWidget {
  final String fullName;
  final String idNo;
  final String phoneNumber;
  final String imageUrl;
  final String username;
  final String office;
  final String purpose;
  final String appointmentId;
  final String date;
  final String time;
  final bool isApproved;

  const AppointmentCard(
      {Key key,
      this.fullName,
      this.idNo,
      this.appointmentId,
      this.phoneNumber,
      this.office,
      this.imageUrl,
      this.username,
      this.purpose,
      this.date,
      this.time,
      this.isApproved})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: size.width < 648 ? size.width / 2 - 60 : 270,
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: CachedNetworkImageProvider(imageUrl),
                      ),
                      title: Text(fullName),
                      subtitle: Text('@$username'),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(phoneNumber),
                              Text(
                                'Contact',
                                style: font(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(time),
                                  Text(
                                    date,
                                    style: font(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('admin')
                                      .doc('appointments')
                                      .collection('requests')
                                      .doc(appointmentId)
                                      .update({
                                    'isApproved': isApproved ? false : true,
                                  });
                                },
                                child: Text(
                                  isApproved ? 'Deny' : 'Approve',
                                  style: font(
                                      color: isApproved
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            Positioned(
              right: 10,
              top: 5,
              child: PopupMenuButton(
                  itemBuilder: (ctx) => [
                        PopupMenuItem(
                            value: 0,
                            child: Text(
                              'Deny',
                              style: font(fontSize: 12),
                            )),
                        PopupMenuItem(
                            value: 1,
                            child: Text(
                              'Postpone',
                              style: font(fontSize: 12),
                            )),
                      ],
                  onSelected: (i) {
                    if (i == 0) {
                      FirebaseFirestore.instance
                          .collection('admin')
                          .doc('appointments')
                          .collection('requests')
                          .doc(appointmentId)
                          .update({
                        'isApproved': false,
                      });
                    }
                  },
                  icon: Icon(Icons.more_vert)),
            )
          ],
        ),
      ),
    );
  }
}
