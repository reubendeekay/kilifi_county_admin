import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/screen/appointments/widgets/appointment_card.dart';

class AppoinmentsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: AlignmentDirectional.topStart,
      width: size.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          AppointmentList(),
        ],
      ),
    );
  }
}

class AppointmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('admin')
          .doc('appointments')
          .collection('Governor')
          .where('isApproved', isNotEqualTo: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          List<DocumentSnapshot> documents = snapshot.data.docs;

          return Responsive(
            desktop: Container(
              child: Center(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent:
                          210, // <== change the height to fit your needs
                    ),
                    itemCount: documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) => AppointmentCard(
                          date: documents[i]['date'],
                          imageUrl: documents[i]['imageUrl'],
                          appointmentId: documents[i]['appointmentId'],
                          username: documents[i]['username'],
                          fullName: documents[i]['name'],
                          time: documents[i]['time'],
                          idNo: documents[i]['idNo'],
                          purpose: documents[i]['purpose'],
                          phoneNumber: documents[i]['phoneNumber'],
                          office: documents[i]['office'],
                          isApproved: documents[i]['isApproved'],
                        )),
              ),
            ),
            tab: Center(
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent:
                        210, // <== change the height to fit your needs
                  ),
                  itemCount: documents.length,
                  itemBuilder: (context, i) => AppointmentCard(
                        date: documents[i]['date'],
                        appointmentId: documents[i]['appointmentId'],
                        imageUrl: documents[i]['imageUrl'],
                        username: documents[i]['username'],
                        fullName: documents[i]['name'],
                        time: documents[i]['time'],
                        idNo: documents[i]['idNo'],
                        purpose: documents[i]['purpose'],
                        phoneNumber: documents[i]['phoneNumber'],
                        office: documents[i]['office'],
                        isApproved: documents[i]['isApproved'],
                      )),
            ),
            mobile: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent:
                      210, // <== change the height to fit your needs
                ),
                itemCount: documents.length,
                itemBuilder: (context, i) => AppointmentCard(
                      date: documents[i]['date'],
                      fullName: documents[i]['name'],
                      time: documents[i]['time'],
                      idNo: documents[i]['idNo'],
                      purpose: documents[i]['purpose'],
                      phoneNumber: documents[i]['phoneNumber'],
                      office: documents[i]['office'],
                      isApproved: documents[i]['isApproved'],
                    )),
          );

          //      GridView.count(
          //   crossAxisCount: getNum(),
          //   shrinkWrap: true,
          //   childAspectRatio: 1 / 1,
          //   children: documents
          //       .map((e) => AppointmentCard(
          //             date: e['date'],
          //             fullName: e['name'],
          //             time: e['time'],
          //             idNo: e['idNo'],
          //             purpose: e['purpose'],
          //             phoneNumber: e['phoneNumber'],
          //             office: e['office'],
          //             isApproved: e['isApproved'],
          //           ))
          //       .toList(),
          // ));
        } else {
          return Container();
        }
      },
    );
  }
}

class AppointmentTile extends StatelessWidget {
  final String fullName;
  final String idNo;
  final String phoneNumber;
  final String office;
  final String purpose;
  final String date;
  final String time;
  final bool isApproved;

  const AppointmentTile(
      {this.fullName,
      this.idNo,
      this.phoneNumber,
      this.purpose,
      this.office,
      this.date,
      this.time,
      this.isApproved});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 300),
      child: Card(
        margin: EdgeInsets.all(7.5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  fullName,
                  style: font()
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              details('ID', idNo),
              details('Phone number', phoneNumber),
              details('Office', office),
              details('Date', date),
              details('Time', time),
              details('Status', isApproved ? 'Pending' : 'Approved'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Cancel',
                      style: font().copyWith(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Approve',
                      style: font().copyWith(color: Colors.green),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget details(String title, String detail) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 100,
              child: Text(
                title,
                style: font().copyWith(color: Colors.grey),
              )),
          SizedBox(
            width: 5,
          ),
          Container(
            child: Text(detail,
                softWrap: true,
                overflow: TextOverflow.fade,
                style: font().copyWith(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
