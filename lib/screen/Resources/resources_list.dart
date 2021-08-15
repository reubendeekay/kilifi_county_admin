import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/helpers/custom_widgets/pie_chart.dart';
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

class ResourcesCategory extends StatefulWidget {
  final String name;
  ResourcesCategory(this.name);

  @override
  _ResourcesCategoryState createState() => _ResourcesCategoryState();
}

class _ResourcesCategoryState extends State<ResourcesCategory> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        width: size.width * 0.20,
        child: Column(
          children: [
            if (size.width > 648)
              Container(
                width: size.width * 0.17,
                margin: EdgeInsets.all(10),
                child: Text(
                  widget.name,
                  style: font()
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            Container(
                width: size.width > 648 ? size.width * 0.26 : double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for a document',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        )),
                  ),
                )),
            searchController.text.isEmpty
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('admin')
                        .doc('documents')
                        .collection(widget.name)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        List<DocumentSnapshot> documents = snapshot.data.docs;

                        return Expanded(
                            child: ListView(
                                shrinkWrap: true,
                                children: documents
                                    .map((e) => DocumentTile(
                                          category: e['category'],
                                          fileName: e['docName'],
                                          url: e['url'],
                                        ))
                                    .toList()));
                      } else {
                        return Container();
                      }
                    },
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('admin')
                        .doc('documents')
                        .collection(widget.name)
                        .where('docName',
                            isGreaterThanOrEqualTo: toBeginningOfSentenceCase(
                                searchController.text))
                        .where('docName',
                            isLessThan: toBeginningOfSentenceCase(
                                searchController.text + 'z'))
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        List<DocumentSnapshot> documents = snapshot.data.docs;

                        return Expanded(
                            child: ListView(
                                children: documents
                                    .map((e) => DocumentTile(
                                          category: e['category'],
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
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInBack,
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
          PieChartSample2(),
          ResourcesCategory('Perfomance Contract Docs')
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
          PieChartSample2(),
          ResourcesCategory('Perfomance Contract Docs'),
        ]),
        mobile: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text('Statistics',
                style:
                    font().copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          PieChartSample2(),
        ]),
      ),
    );
  }
}

class DocumentTile extends StatelessWidget {
  final String fileName;
  final String url;
  final String category;
  DocumentTile({this.fileName, this.category, this.url});

  final nameController = TextEditingController();
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
      child: Stack(
        children: [
          Row(
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
          Positioned(
              top: 0,
              right: 3,
              child: PopupMenuButton(
                  itemBuilder: (ctx) => [
                        PopupMenuItem(
                            value: 0,
                            child: Text(
                              'Update',
                              style: font(fontSize: 12),
                            )),
                        PopupMenuItem(
                            value: 1,
                            child: Text(
                              'Delete',
                              style: font(fontSize: 12),
                            )),
                        PopupMenuItem(
                            value: 2,
                            child: Text(
                              'Download',
                              style: font(fontSize: 12),
                            )),
                      ],
                  onSelected: (i) {
                    if (i == 0) {
                      showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                                child: Card(
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    child: Column(
                                      children: [
                                        TextField(
                                          maxLines: null,
                                          controller: nameController,
                                          decoration: InputDecoration(
                                              labelText: 'Document name',
                                              border: InputBorder.none),
                                        ),
                                        Spacer(),
                                        RaisedButton(
                                          onPressed: () {
                                            if (nameController.text.isNotEmpty)
                                              FirebaseFirestore.instance
                                                  .collection('admin')
                                                  .doc('documents')
                                                  .collection(category)
                                                  .doc(fileName)
                                                  .update({
                                                'docName': nameController.text
                                              });
                                          },
                                          color: kPrimary,
                                          child: Text(
                                            'Update',
                                            style: font(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    }
                    if (i == 1) {
                      FirebaseFirestore.instance
                          .collection('admin')
                          .doc('documents')
                          .collection(category)
                          .doc(fileName)
                          .delete();
                    }
                    if (i == 2) {
                      html.window.open(url, fileName);
                    }
                  },
                  child: Icon(
                    Icons.more_vert,
                    size: 16,
                    color: kPrimary,
                  )))
        ],
      ),
    );
  }
}

class ResourcesMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.9,
      child: DefaultTabController(
        length: 4,
        initialIndex: 1,
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
              labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
                Tab(
                  child: Text('Budget & Finances'),
                ),
                Tab(child: Text('Perfomance Contract Docs')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ResourcesCategory('Downloads'),
              ResourcesCategory('Departments'),
              ResourcesCategory('Budget&Finances'),
              ResourcesCategory('Perfomance Contract Docs'),
            ],
          ),
        ),
      ),
    );
  }
}
