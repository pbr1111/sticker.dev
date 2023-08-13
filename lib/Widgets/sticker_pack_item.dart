import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sticker_dev/constants/constants.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:sticker_dev/screens/sticker_pack_info.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';

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
                    builder: (context) => StickerPackInfoScreen(
                          stickerPack: stickerPack,
                        )));
          },
          title: Text(stickerPack.name ?? ""),
          subtitle: Text(stickerPack.publisher ?? ""),
          leading: Image.network(
            "${BASE_URL}/${stickerPack.identifier}/${stickerPack.trayImageFile}",
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                  height: 50,
                  width: 50,
                  child: Shimmer.fromColors(
                      baseColor: Theme.of(context).focusColor,
                      highlightColor: Theme.of(context).hoverColor,
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white))));
            },
          ),
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
