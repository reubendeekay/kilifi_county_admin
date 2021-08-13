import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/screen/forum/forum_container.dart';
import 'package:kilifi_county_admin/screen/forum/forum_side.dart';

class ForumMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.topStart,
      child: DefaultTabController(
        length: 2,
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
            children: [ForumMobilePosts(), ForumSide()],
          ),
        ),
      ),
    );
  }
}

class ForumMobilePosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SendTweet(),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                  child: Text(
                'Latest Posts',
                style: GoogleFonts.tinos(
                    fontWeight: FontWeight.w800, fontSize: 24),
              )),
            ),
            JobOpportunitiesPosts(),
          ],
        ),
      ),
    );
  }
}
