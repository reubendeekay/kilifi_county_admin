import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

Widget cacheImage({
  String url,
  double width,
  BoxFit fit,
}) {
  return CachedNetworkImage(
    imageUrl: url != null ? url : "http://via.placeholder.com/350x150",
    fit: fit != null ? fit : BoxFit.cover,
    width: width != null ? width : null,
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey[200],
      child: Text(
        'Shimmer',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
