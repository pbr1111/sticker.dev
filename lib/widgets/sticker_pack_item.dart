import 'package:flutter/material.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:sticker_dev/widgets/sticker_image.dart';

import '../helpers/sticker_path_helpers.dart';
import '../screens/sticker_pack_screen.dart';

class StickerPackItem extends StatelessWidget {
  final StickerPack stickerPack;

  StickerPackItem({
    Key? key,
    required this.stickerPack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        child: ListTile(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (context) => StickerPackScreen(
                      stickerPack: stickerPack,
                    )));
          },
          title: Text(stickerPack.name),
          subtitle: Text(stickerPack.publisher),
          leading: SizedBox(
              width: 50,
              height: 50,
              child: StickerImage(stickerPath: getTrayImageUrl(stickerPack))),
        ),
      ),
    );
  }
}
