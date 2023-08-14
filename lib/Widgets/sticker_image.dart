import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StickerImage extends StatefulWidget {
  final String imageRef;

  const StickerImage({Key? key, required this.imageRef}) : super(key: key);

  @override
  State<StickerImage> createState() => _StickerImageState();
}

class _StickerImageState extends State<StickerImage> {
  String? _imageUrl;

  Future<void> _getImageUrl() async {
    var ref = FirebaseStorage.instance.ref(widget.imageRef);
    var downloadUrl = await ref.getDownloadURL();
    setState(() {
      _imageUrl = downloadUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    _getImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return _imageUrl == null
        ? const StickerImageShimmer()
        : CachedNetworkImage(
            imageUrl: _imageUrl!,
            fit: BoxFit.fill,
            fadeOutDuration: Duration(milliseconds: 100),
            placeholder: (_, _2) => const StickerImageShimmer());
  }
}

class StickerImageShimmer extends StatelessWidget {
  const StickerImageShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).focusColor,
        highlightColor: Theme.of(context).hoverColor,
        child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white)));
  }
}
