import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/helpers/responsive.dart';

class ResourcesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.62,
      child: Row(
        children: [
          ResourcesCategory('Downloads'),
          ResourcesCategory('Departments'),
          ResourcesCategory('Budget&Finances'),
        ],
      ),
    );
  }
}

class ResourcesCategory extends StatelessWidget {
  final String name;
  ResourcesCategory(this.name);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        width: size.width * 0.20,
        child: Column(
          children: [
            Container(
              width: size.width * 0.17,
              margin: EdgeInsets.all(10),
              child: Text(
                name,
                style:
                    font().copyWith(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('admin')
                  .doc('documents')
                  .collection(name)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  List<DocumentSnapshot> documents = snapshot.data.docs;

                  return Expanded(
                      child: ListView(
                          children: documents
                              .map((e) => DocumentTile(
                                    fileName: e['docName'],
                                    url: e['url'],
                                  ))
                              .toList()));
                } else {
                  return Container();
                }
              },
            )
          ],
        ));
  }
}

class ResourcesSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Responsive(
        desktop:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text('Statistics',
                style:
                    font().copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          statistic(),
          statistic(),
          Expanded(child: ResourcesCategory('Perfomance Contract Docs'))
        ]),
        tab: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text('Statistics',
                style:
                    font().copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          statistic(),
          statistic(),
          Expanded(child: ResourcesCategory('Perfomance Contract Docs'))
        ]),
        mobile: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text('Statistics',
                style:
                    font().copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          statistic(),
          statistic(),
        ]),
      ),
    );
  }

  Widget statistic() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.blue[50], borderRadius: BorderRadius.circular(30)),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total files',
            style: font().copyWith(color: Colors.blue, fontSize: 15),
          ),
          SizedBox(width: 20),
          CircleAvatar(
            radius: 20,
            child: Text(
              '70',
              style: font().copyWith(
                  fontSize: 18, fontWeight: FontWeight.w900, color: kPrimary),
            ),
          )
        ],
      )),
    );
  }
}

class DocumentTile extends StatelessWidget {
  final String fileName;
  final String url;
  DocumentTile({this.fileName, this.url});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return HoverContainer(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      width: size.width * 0.17,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      hoverDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: kBackground,
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.filePdf,
            size: 30,
            color: Colors.red,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Container(
                  child: Text(
            fileName,
            softWrap: true,
            overflow: TextOverflow.fade,
          )))
        ],
      ),
    );
  }
}

class ResourcesMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [
              RaisedButton(
                onPressed: () {},
                color: kBackground.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'Upload document',
                  style: font().copyWith(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
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
                  child: Text('Downloads'),
                ),
                Tab(
                  child: Text('Departments'),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ResourcesCategory('Downloads'),
              ResourcesCategory('Departments'),
            ],
          ),
        ),
      ),
    );
  }
}
