import 'package:flutter/material.dart';
import 'package:sticker_dev/app_localizations.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:sticker_dev/widgets/sticker_image.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';

import '../helpers/sticker_path_helpers.dart';
import '../screens/sticker_pack_screen.dart';

class StickerPackItemExtended extends StatelessWidget {
  final StickerPack stickerPack;

  StickerPackItemExtended({
    Key? key,
    required this.stickerPack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WhatsappStickersHandler _whatsappStickersHandler =
        WhatsappStickersHandler();

    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => StickerPackScreen(
                        stickerPack: stickerPack,
                      )));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stickerPack.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Row(children: [
                                  Text(stickerPack.publisher),
                                  Text(" - "),
                                  Text(AppLocalizations.of(context)!
                                      .pack_total_stickers(
                                          stickerPack.stickers.length))
                                ]),
                              ]),
                          SizedBox(
                              height: 38,
                              child: FutureBuilder(
                                  future: _whatsappStickersHandler
                                      .isStickerPackInstalled(
                                          stickerPack.identifier),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    return snapshot.connectionState ==
                                                ConnectionState.waiting ||
                                            snapshot.data == null
                                        ? const SizedBox()
                                        : TextButton.icon(
                                            icon: Icon(
                                              snapshot.data!
                                                  ? Icons.check
                                                  : Icons.add,
                                            ),
                                            label: Text(snapshot.data!
                                                ? AppLocalizations.of(context)!
                                                    .remove
                                                : AppLocalizations.of(context)!
                                                    .add),
                                            onPressed: () {},
                                          );
                                  }))
                        ]),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        child: ListView.builder(
                          // This next line does the trick.
                          scrollDirection: Axis.horizontal,
                          itemCount: stickerPack.stickers.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: 60,
                            height: 60,
                            child: StickerImage(
                                stickerPath: getStickerImageUrl(
                                    stickerPack.stickers[index])),
                          ),
                        ))
                  ],
                ))));
  }
}
