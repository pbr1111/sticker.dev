import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sticker_dev/helpers/url_helpers.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';

import '../models/sticker_data.dart';

Future<void> addPackToWhatsApp(StickerPack stickerPack) async {
  Map<String, List<String>> stickers = <String, List<String>>{};
  var trayImage = '';
  final downloads = <Future>[];
  var applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
  var stickersDirectory = Directory(
      '${applicationDocumentsDirectory.path}/${stickerPack.identifier}');
  await stickersDirectory.create(recursive: true);

  var traySavePath =
      '${stickersDirectory.path}/${stickerPack.trayImageFile.toLowerCase()}';

  downloads.add(DefaultCacheManager()
      .getSingleFile(getStickerImageUrl(stickerPack.trayImageRef))
      .then((value) => value.copy(traySavePath)));

  trayImage = WhatsappStickerImageHandler.fromFile(traySavePath).path;

  for (var sticker in stickerPack.stickers) {
    var savePath =
        "${stickersDirectory.path}/${(sticker.imageFile).toLowerCase()}";

    downloads.add(DefaultCacheManager()
        .getSingleFile(getStickerImageUrl(sticker.imageRef))
        .then((value) => value.copy(savePath)));

    stickers[WhatsappStickerImageHandler.fromFile(savePath).path] =
        sticker.emojis;
  }

  await Future.wait(downloads);

  final WhatsappStickersHandler _whatsappStickersHandler =
      WhatsappStickersHandler();
  return await _whatsappStickersHandler.addStickerPack(
    stickerPack.identifier,
    stickerPack.name,
    stickerPack.publisher,
    trayImage,
    stickerPack.publisherWebsite,
    stickerPack.privacyPolicyWebsite,
    stickerPack.licenseAgreementWebsite,
    stickerPack.animatedStickerPack ?? false,
    stickers,
  );
}
