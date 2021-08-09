import 'package:flutter/material.dart';
import 'package:kilifi_county_admin/helpers/responsive.dart';
import 'package:kilifi_county_admin/screen/news/widgets/articles.dart';
import 'package:kilifi_county_admin/screen/news/widgets/posters_container.dart';
import 'package:kilifi_county_admin/screen/news/widgets/top_news.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Responsive(
        desktop: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 2),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: ListView(
                    children: [
                      TopAddNews(),
                      SizedBox(height: 10),
                      ArticlesContainer()
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              PostersContainer(),
            ],
          ),
        ),
        tab: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 2),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: ListView(
                    children: [
                      TopAddNews(),
                      SizedBox(height: 10),
                      ArticlesContainer()
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              PostersContainer(),
            ],
          ),
        ),
        mobile: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 2),
          child: Container(
            child: ListView(
              children: [
                TopAddNews(),
                SizedBox(height: 10),
                // PostersContainer(),
                AddPosterTile(),
                SizedBox(height: 10),
                ArticlesContainer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
