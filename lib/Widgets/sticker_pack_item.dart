import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sticker_dev/widgets/sticker.dart';
import 'package:sticker_dev/constants/constants.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';

import '../screens/sticker_pack_detail.dart';

class StickerPackItem extends StatelessWidget {
  final StickerPacks stickerPack;

  StickerPackItem({
    Key? key,
    required this.stickerPack,
  }) : super(key: key);

  Widget addStickerPackButton(BuildContext context, bool isInstalled,
      WhatsappStickersHandler _whatsappStickersHandler) {
    stickerPack.isInstalled = isInstalled;

    // TODO Review the behavior of this button (add/check?)
    return TextButton.icon(
      icon: Icon(
        isInstalled ? Icons.check : Icons.add,
      ),
      label: Text(isInstalled
          ? AppLocalizations.of(context)!.remove
          : AppLocalizations.of(context)!.add),
      onPressed: () async {
        // TODO
        throw 'Not implemented';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final WhatsappStickersHandler _whatsappStickersHandler =
        WhatsappStickersHandler();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StickerPackDetailScreen(
                          stickerPack: stickerPack,
                        )));
          },
          title: Text(stickerPack.name ?? ""),
          subtitle: Text(stickerPack.publisher ?? ""),
          leading: Sticker(
              imageUrl:
                  '${BASE_URL}/${stickerPack.identifier}/${stickerPack.trayImageFile}',
              size: 50),
          trailing: FutureBuilder(
              future: _whatsappStickersHandler
                  .isStickerPackInstalled(stickerPack.identifier as String),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: const CircularProgressIndicator())
                    : addStickerPackButton(
                        context,
                        snapshot.data as bool,
                        _whatsappStickersHandler,
                      );
              }),
        ),
      ),
    );
  }
}
