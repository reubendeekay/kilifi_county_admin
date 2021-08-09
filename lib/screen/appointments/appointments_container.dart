import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

class AppoinmentsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: AlignmentDirectional.topStart,
      child: DefaultTabController(
        length: size.width > 871 ? 2 : 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              // indicator: BoxDecoration(
              //     color: kPrimary, borderRadius: BorderRadius.circular(10)),
              labelStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              onTap: (index) {
                // Tab index when user select it, it start from zero
              },
              tabs: [
                Tab(
                  child: Text('Latest'),
                ),
                Tab(
                  child: Text('Pending'),
                ),
                if (size.width < 871)
                  Tab(
                    child: Text('Approved'),
                  ),
              ],
            ),
            title: Center(
              child: Text(
                'Appointments',
                style: font().copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 28),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              AppointmentList(),
              AppointmentList(),
              if (size.width < 871) AppointmentList(),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int getNum() {
      if (size.width < 1290) {
        return 2;
      } else if (size.width < 1095) {
        return 3;
      } else if (size.width < 871) {
        return 3;
      } else if (size.width < 500) {
        return 2;
      } else if (size.width < 440) {
        return 1;
      } else {
        return 3;
      }
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('admin')
          .doc('appointments')
          .collection('Governor')
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          List<DocumentSnapshot> documents = snapshot.data.docs;

          return Container(
              child: GridView.count(
            crossAxisCount: getNum(),
            shrinkWrap: true,
            childAspectRatio: 1 / 1,
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
          ));
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
