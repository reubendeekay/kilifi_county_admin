import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class VerificationRequests extends StatefulWidget {
  @override
  _VerificationRequestsState createState() => _VerificationRequestsState();
}

class _VerificationRequestsState extends State<VerificationRequests> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.31,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Verification Requests',
              style: font().copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              width: size.width * 0.26,
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
                      hintText: 'Search for a user',
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
                      .doc('verification_requests')
                      .collection('users')
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData && !snapshot.hasError) {
                      List<DocumentSnapshot> documents = snapshot.data.docs;

                      return ListView(
                        shrinkWrap: true,
                        children: documents
                            .map((e) => VerificationRequestTile(
                                fullName: e['fullName'],
                                imageUrl: e['imageUrl'],
                                username: e['username'],
                                links: e['links'],
                                notability: e['notability'],
                                document: e['url'],
                                email: e['email'],
                                isVerified: e['isVerified'],
                                nationalId: e['nationalId'],
                                userId: e['userId']))
                            .toList(),
                      );
                    } else {
                      return Container();
                    }
                  })
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('admin')
                      .doc('verification_requests')
                      .collection('users')
                      .where('fullName',
                          isGreaterThanOrEqualTo:
                              toBeginningOfSentenceCase(searchController.text))
                      .where('fullName',
                          isLessThan: toBeginningOfSentenceCase(
                              searchController.text + 'z'))
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData && !snapshot.hasError) {
                      List<DocumentSnapshot> documents = snapshot.data.docs;

                      return ListView(
                        shrinkWrap: true,
                        children: documents
                            .map((e) => VerificationRequestTile(
                                fullName: e['fullName'],
                                imageUrl: e['imageUrl'],
                                username: e['username'],
                                links: e['links'],
                                notability: e['notability'],
                                document: e['url'],
                                email: e['email'],
                                isVerified: e['isVerified'],
                                nationalId: e['nationalId'],
                                userId: e['userId']))
                            .toList(),
                      );
                    } else {
                      return Container();
                    }
                  }),
        ],
      ),
    );
  }
}

// FirebaseFirestore.instance
//               .collection('admin')
//               .doc('verification_requests')
//               .collection('users')
//               .doc(user.userId)
//               .set({
//             'fullName': fullName,
//             'username': user.username,
//             'notability': notability,
//             'document': url,
//             'links': [link1, link2, link3]
//           }, SetOptions(merge: true));

class VerificationRequestTile extends StatelessWidget {
  final String fullName;
  final String username;
  final String imageUrl;
  final String email;
  final String document;
  final String notability;
  final List<dynamic> links;

  final String userId;

  final String nationalId;

  final bool isVerified;

  const VerificationRequestTile(
      {this.fullName,
      this.username,
      this.imageUrl,
      this.notability,
      this.email,
      this.document,
      this.userId,
      this.links,
      this.nationalId,
      this.isVerified});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBox,
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/wall.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                    bottom: -30,
                    left: 20,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: CachedNetworkImageProvider(imageUrl),
                    )),
                Positioned(
                    right: 10,
                    bottom: -10,
                    child: Container(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Card(
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: GestureDetector(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('admin')
                                    .doc('verification_requests')
                                    .collection('users')
                                    .doc(userId)
                                    .update({
                                  'isVerified': true,
                                });
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  child: Text(
                                    'Approve',
                                    style: font().copyWith(color: Colors.white),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Card(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: GestureDetector(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('admin')
                                    .doc('verification_requests')
                                    .collection('users')
                                    .doc(userId)
                                    .update({
                                  'isVerified': true,
                                });
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  child: Text(
                                    'Deny',
                                    style: font().copyWith(color: Colors.white),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      fullName,
                      style: font()
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      '@$username',
                      style: font().copyWith(color: Colors.grey),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      'ID : $nationalId',
                      style: font().copyWith(color: Colors.grey),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      notability,
                      style: font().copyWith(color: Colors.grey),
                    ),
                  ),
                  Column(
                    children: List.generate(
                      links.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(vertical: 1),
                        child: GestureDetector(
                          onTap: () async {
                            await _launchInBrowser(links[index]);
                          },
                          child: Text(
                            links[index],
                            style: font().copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
