import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:kilifi_county_admin/helpers/cache_image.dart';
import 'package:kilifi_county_admin/helpers/constants.dart';
import 'package:kilifi_county_admin/providers/post_provider.dart';
import 'package:kilifi_county_admin/screen/forum/widgets/like_widget.dart';

class ForumPictureTile extends StatelessWidget {
  final Post post;
  ForumPictureTile(this.post);
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
                backgroundImage: CachedNetworkImageProvider(post.user.imageUrl),
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
                          post.user.fullName,
                          style:
                              font(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        if (post.user.isVerified)
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
                      '@${post.user.username}',
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
            margin: EdgeInsets.only(left: 30),
            height: size.height * 0.55,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: cacheImage(
                url: post.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 38,
            child: Row(
              children: [
                SizedBox(
                    width: 35,
                    child: LikeWidget(
                      post: post,
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
          if (post.likes.isNotEmpty)
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
                                  post.likes[0]['images'],
                                ))),
                        if (post.likes.length > 1)
                          Positioned(
                              left: 12,
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: CachedNetworkImageProvider(
                                    post.likes[1]['images'],
                                  ))),
                        if (post.likes.length > 2)
                          Positioned(
                              left: 24,
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: CachedNetworkImageProvider(
                                    post.likes[2]['images'],
                                  ))),
                        if (post.likes.length > 3)
                          Positioned(
                              left: 36,
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: CachedNetworkImageProvider(
                                    post.likes[3]['images'],
                                  ))),
                        if (post.likes.length > 4)
                          Positioned(
                              left: 48,
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: CachedNetworkImageProvider(
                                    post.likes[4]['images'],
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
                          post.likes.last['usernames'],
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        if (post.likes.length > 1)
                          Text(
                            ' and ',
                            style: TextStyle(fontSize: 14),
                          ),
                        Text(
                          post.likes.length > 1
                              ? '${post.likes.length} others'
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
                      text: '${post.user.username} ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      children: <TextSpan>[
                    TextSpan(
                      text: post.description,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  ])),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          if (post.comments.length > 0)
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
