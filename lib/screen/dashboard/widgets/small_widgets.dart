import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GreetingsTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 1200),
      margin: EdgeInsets.symmetric(
          vertical: size.width > 820 ? 25 : 100, horizontal: 45),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 3),
          child: DefaultTextStyle(
            style: GoogleFonts.catamaran(
                color: Colors.white,
                fontSize: size.width > 700 ? 50.0 : 35,
                fontWeight: FontWeight.w900,
                shadows: [Shadow(blurRadius: 5, color: Colors.black)]),
            child: AnimatedTextKit(
              pause: Duration(seconds: 5),
              animatedTexts: [
                TypewriterAnimatedText('How are you, Reuben'),
                TypewriterAnimatedText('With Great Power,'),
                TypewriterAnimatedText('Comes Great Responsibility'),
              ],
              onTap: () {},
            ),
          ),
        ),
        Container(
            child: Text(
          'Here is what is up and running as an admin',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 5, color: Colors.black)],
          ),
        ))
      ]),
    );
  }
}

class DashboardCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        child: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.black,
                  Colors.black,
                  Colors.transparent
                ],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: CarouselSlider(
                items: [
                  'assets/images/wall.jpg',
                  'assets/images/wall1.jpg',
                  'assets/images/wall2.jpg',
                  'assets/images/wall3.jpg',
                  'assets/images/wall4.jpg',
                ]
                    .map((e) => Container(
                        width: size.width,
                        child: Image.asset(e, fit: BoxFit.fill)))
                    .toList(),
                options: CarouselOptions(
                  height: 450,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 10),
                  autoPlayAnimationDuration: Duration(seconds: 3),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ))));
  }
}
