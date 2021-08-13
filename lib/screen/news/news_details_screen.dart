import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';

import 'package:kilifi_county_admin/models/news_model.dart';

class NewsDetailsScreen extends StatelessWidget {
  static const routeName = '/news-details';
  @override
  Widget build(BuildContext context) {
    final news = ModalRoute.of(context).settings.arguments as NewsModel;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackground.withOpacity(0.5),
      body: Container(
        color: kBackground.withOpacity(0.5),
        margin: EdgeInsets.symmetric(
          horizontal: size.width > 800 ? size.width * 0.1 : 0,
        ),
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                height: 300,
                child: Image.network(
                  news.image,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 10, horizontal: size.width * 0.1),
                child: Text(
                  news.title,
                  style: GoogleFonts.tinos(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 20, horizontal: size.width * 0.1),
                child: Text(
                  news.article,
                  style: GoogleFonts.tinos(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
