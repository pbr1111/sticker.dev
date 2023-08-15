import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StickerPackItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).focusColor,
        highlightColor: Theme.of(context).hoverColor,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 19, horizontal: 16),
            child: Row(children: [
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 16,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 160,
                      height: 14,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                    )
                  ]),
            ])));
  }
}
