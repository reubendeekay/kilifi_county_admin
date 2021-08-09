import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/screen/news/add_article.dart';

class TopAddNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: kPrimary, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Whats New?',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.33,
                  child: Text(
                    'Is there anything happenind worth sharing?. Give the users detailed infomation about the progess and running of the County.',
                    softWrap: true,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  )),
              SizedBox(height: 20),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddArticle.routeName);
                  },
                  color: kBackground,
                  child: Text(
                    'Write a new article',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  )),
              SizedBox(height: 20),
            ],
          ),
          Spacer(),
          Container(
              width: size.width * 0.15,
              height: size.width * 0.15,
              child:
                  Image.asset('assets/images/news_cat.png', fit: BoxFit.fill))
        ],
      ),
    );
  }
}
