import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        CircularProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
