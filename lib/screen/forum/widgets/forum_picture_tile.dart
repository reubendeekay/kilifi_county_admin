import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:kilifi_county_admin/helpers/cache_image.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/providers/post_provider.dart';
import 'package:kilifi_county_admin/screen/forum/widgets/like_widget.dart';

class ForumPictureTile extends StatefulWidget {
  final Post post;
  ForumPictureTile(this.post);

  @override
  _ForumPictureTileState createState() => _ForumPictureTileState();
}

class _ForumPictureTileState extends State<ForumPictureTile> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<Widget> imageSliders;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return HoverContainer(
      hoverDecoration: BoxDecoration(color: Colors.grey[200].withOpacity(0.4)),
      margin: size.width > 648
          ? EdgeInsets.symmetric(horizontal: size.width * 0.1)
          : EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.grey[200])),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage:
                    CachedNetworkImageProvider(widget.post.user.imageUrl),
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          widget.post.user.fullName,
                          style:
                              font(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        if (widget.post.user.isVerified)
                          Icon(
                            Icons.verified,
                            size: 13,
                            color: Colors.blue,
                          )
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      '@${widget.post.user.username}',
                      style: font(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Stack(children: [
              CarouselSlider(
                items: widget.post.imageUrl
                    .map((e) => Container(
                          margin: EdgeInsets.only(left: 30),
                          height: size.height * 0.55,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: cacheImage(
                              url: e,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                    .toList(),
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    height: size.height * 0.55,
                    disableCenter: true,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Align(
                // bottom: 5,
                alignment: Alignment(1, 1),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.post.imageUrl.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 6.0,
                        height: 6.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 38,
            child: Row(
              children: [
                SizedBox(
                    width: 35,
                    child: LikeWidget(
                      post: widget.post,
                      size: 26,
                      tweet: false,
                    )),
                IconButton(
                    onPressed: () async {
                      // await Navigator.of(context).pushNamed(
                      //     CommentsScreen.routeName,
                      //     arguments: post);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.comment,
                      size: 22,
                    )),
              ],
            ),
          ),
          if (widget.post.likes.isNotEmpty)
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: (size.width) - 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 40,
                    child: Stack(
                      children: [
                        Positioned(
                            left: 0,
                            child: CircleAvatar(
                                radius: 14,
                                backgroundImage: CachedNetworkImageProvider(
                                  widget.post.likes[0]['images'],
                                ))),
                        if (widget.post.likes.length > 1)
                          Positioned(
                              left: 12,
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: CachedNetworkImageProvider(
                                    widget.post.likes[1]['images'],
                                  ))),
                        if (widget.post.likes.length > 2)
                          Positioned(
                              left: 24,
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: CachedNetworkImageProvider(
                                    widget.post.likes[2]['images'],
                                  ))),
                        if (widget.post.likes.length > 3)
                          Positioned(
                              left: 36,
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: CachedNetworkImageProvider(
                                    widget.post.likes[3]['images'],
                                  ))),
                        if (widget.post.likes.length > 4)
                          Positioned(
                              left: 48,
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: CachedNetworkImageProvider(
                                    widget.post.likes[4]['images'],
                                  ))),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.likes.last['usernames'],
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        if (widget.post.likes.length > 1)
                          Text(
                            ' and ',
                            style: TextStyle(fontSize: 14),
                          ),
                        Text(
                          widget.post.likes.length > 1
                              ? '${widget.post.likes.length} others'
                              : ' liked this',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          GestureDetector(
            // onTap: () => Navigator.of(context)
            //     .pushNamed(CommentsScreen.routeName, arguments: post),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(shape: BoxShape.rectangle),
              margin: EdgeInsets.only(left: 10),
              width: double.infinity,
              child: RichText(
                  text: TextSpan(
                      text: '${widget.post.user.username} ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      children: <TextSpan>[
                    TextSpan(
                      text: widget.post.description,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  ])),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          if (widget.post.comments.length > 0)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                // onTap: () => Navigator.of(context).pushNamed(
                //     CommentsScreen.routeName,
                //     arguments: post),
                child: Text(
                  'View comments',
                  style:
                      TextStyle(color: kPrimary, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          // Divider()
        ],
      ),
    );
  }
}
