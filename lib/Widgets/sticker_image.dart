import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StickerImage extends StatelessWidget {
  static const double DEFAULT_SIZE = 70;

  final String imageUrl;
  final double? size;

  StickerImage({Key? key, required this.imageUrl, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.fill,
        height: size ?? DEFAULT_SIZE,
        width: size ?? DEFAULT_SIZE,
        fadeOutDuration: Duration(milliseconds: 100),
        placeholder: (_, _2) => Shimmer.fromColors(
            baseColor: Theme.of(context).focusColor,
            highlightColor: Theme.of(context).hoverColor,
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white))));
  }
}
