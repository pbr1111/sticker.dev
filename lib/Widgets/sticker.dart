import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Sticker extends StatelessWidget {
  static const double DEFAULT_SIZE = 70;

  final String imageUrl;
  final double? size;

  Sticker({Key? key, required this.imageUrl, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.fill,
      height: size ?? DEFAULT_SIZE,
      width: size ?? DEFAULT_SIZE,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
            height: size ?? DEFAULT_SIZE,
            width: size ?? DEFAULT_SIZE,
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).focusColor,
                highlightColor: Theme.of(context).hoverColor,
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white))));
      },
    );
  }
}
