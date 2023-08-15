import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class StickerImage extends StatelessWidget {
  final String stickerPath;

  const StickerImage({Key? key, required this.stickerPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: stickerPath,
        fit: BoxFit.fill,
        fadeOutDuration: Duration(milliseconds: 100),
        placeholder: (_, _2) => Shimmer.fromColors(
            baseColor: Theme.of(context).focusColor,
            highlightColor: Theme.of(context).hoverColor,
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white))));
  }
}
