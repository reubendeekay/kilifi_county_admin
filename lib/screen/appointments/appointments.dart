import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/appointments/appointments_container.dart';
import 'package:kilifi_county_admin/screen/appointments/widgets/calendar.dart';

class Apppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Flexible(child: AppoinmentsContainer()),
          if (size.width > 871)
            Card(
              elevation: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    UserCalendar(),
                    Center(
                      child: Container(
                        child: Text(
                          'Approved Appointments',
                          style: font().copyWith(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                        width: 270,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('admin')
                                .doc('appointments')
                                .collection('Governor')
                                .snapshots(),
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData && !snapshot.hasError) {
                                List<DocumentSnapshot> documents =
                                    snapshot.data.docs;

                                return Container(
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: documents
                                        .map((e) => AppointmentTile(
                                              date: e['date'],
                                              fullName: e['name'],
                                              time: e['time'],
                                              idNo: e['idNo'],
                                              purpose: e['purpose'],
                                              phoneNumber: e['phoneNumber'],
                                              office: e['office'],
                                              isApproved: e['isApproved'],
                                            ))
                                        .toList(),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            })),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
