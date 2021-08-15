import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/screen/Resources/resources.dart';
import 'package:kilifi_county_admin/screen/appointments/appointments.dart';
import 'package:kilifi_county_admin/screen/chat/chat.dart';
import 'package:kilifi_county_admin/screen/dashboard/dashboard.dart';
import 'package:kilifi_county_admin/screen/news/news_screen.dart';
import 'package:kilifi_county_admin/screen/forum/forum.dart';

DrawerItem items = DrawerItems.home;
int currentIndex = 0;

class Home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: Scaffold(
        backgroundColor: kBackground,
        body: Row(
          children: [mainDrawer(), Expanded(child: getSelectedPage())],
        ),
      ),
      tab: Scaffold(
          appBar: AppBar(
            iconTheme: IconTheme.of(context).copyWith(color: kBackground),
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 50,
          ),
          drawer: mainDrawer(),
          backgroundColor: kBackground,
          body: getSelectedPage()),
      mobile: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconTheme.of(context).copyWith(color: kBackground),
            elevation: 0,
            toolbarHeight: 50,
          ),
          drawer: mainDrawer(),
          backgroundColor: kBackground,
          body: getSelectedPage()),
    );
  }

  Widget mainDrawer() {
    final page = DrawerItems.all;

    return SizedBox(
      width: 200,
      child: Drawer(
        elevation: 0,
        child: Container(
          color: kBackground,
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.all(20),
                  height: 80,
                  child: Image.asset(
                    'assets/images/logo.png',
                  )),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        items = page[i];

                        currentIndex = i;
                      });
                    },
                    child: DrawerTile(
                      title: page[i].title,
                      icon: page[i].icon,
                      index: page[i].index,
                    ),
                  );
                },
                itemCount: page.length,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

Widget getSelectedPage() {
  switch (items) {
    case DrawerItems.home:
      return Dashboard();
      break;
    case DrawerItems.news:
      return NewsScreen();
      break;
    case DrawerItems.forum:
      return Forum();
      break;
    case DrawerItems.appointments:
      return Apppointments();
      break;
    case DrawerItems.chat:
      return Chat();
      break;
    case DrawerItems.resources:
      return Resources();
      break;
    default:
      return Dashboard();
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final int index;

  DrawerTile({
    this.icon,
    this.title,
    this.index,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 900),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))),
        margin: EdgeInsets.fromLTRB(10, 8, 0, 8),
        child: ListTile(
            leading: Icon(
              icon,
              color: currentIndex == index ? kBackground : Colors.white,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            dense: true,
            minLeadingWidth: 10,
            selectedTileColor: Colors.white,
            focusColor: Colors.white,
            title: Text(
              title,
              style: TextStyle(
                  fontSize: currentIndex == index ? 18 : 16,
                  color: currentIndex == index ? kBackground : Colors.white,
                  fontWeight: FontWeight.bold),
            )));
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final int index;
  const DrawerItem({this.title, this.icon, this.index});
}

class DrawerItems {
  static const home =
      DrawerItem(title: 'Dashboard', icon: Icons.home, index: 0);
  static const news =
      DrawerItem(title: 'News', icon: Icons.new_label_sharp, index: 1);
  static const forum =
      DrawerItem(title: 'Forum', icon: FontAwesomeIcons.twitter, index: 2);

  static const appointments = DrawerItem(
      title: 'Appointments', icon: Icons.calendar_today_outlined, index: 3);
  static const chat = DrawerItem(
      title: 'Customer Care', icon: FontAwesomeIcons.comment, index: 4);
  static const resources =
      DrawerItem(title: 'Resources', icon: FontAwesomeIcons.filePdf, index: 5);

  static final all = [
    home,
    news,
    forum,
    appointments,
    chat,
    resources,
  ];
}
