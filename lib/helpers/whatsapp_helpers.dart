import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sticker_dev/helpers/path_helpers.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';

import '../models/sticker_data.dart';

Future<void> addPackToWhatsApp(StickerPack stickerPack) async {
  Map<String, List<String>> stickers = <String, List<String>>{};
  var trayImage = '';
  final dio = Dio();
  final downloads = <Future>[];
  var applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
  var stickersDirectory = Directory(
      '${applicationDocumentsDirectory.path}/${stickerPack.identifier}');
  await stickersDirectory.create(recursive: true);

  downloads.add(
    dio.download(
      getStickerTrayUrl(stickerPack),
      "${stickersDirectory.path}/${stickerPack.trayImageFile!.toLowerCase()}",
    ),
  );
  trayImage = WhatsappStickerImageHandler.fromFile(
          "${stickersDirectory.path}/${stickerPack.trayImageFile!.toLowerCase()}")
      .path;

  for (var sticker in stickerPack.stickers!) {
    var savePath =
        "${stickersDirectory.path}/${(sticker.imageFile as String).toLowerCase()}";
    downloads.add(
      dio.download(
        getStickerImageUrl(stickerPack, sticker),
        savePath,
      ),
    );

    stickers[WhatsappStickerImageHandler.fromFile(
            "${stickersDirectory.path}/${(sticker.imageFile as String).toLowerCase()}")
        .path] = sticker.emojis as List<String>;
  }

  await Future.wait(downloads);

  final WhatsappStickersHandler _whatsappStickersHandler =
      WhatsappStickersHandler();
  return await _whatsappStickersHandler.addStickerPack(
    stickerPack.identifier,
    stickerPack.name as String,
    stickerPack.publisher as String,
    trayImage,
    stickerPack.publisherWebsite,
    stickerPack.privacyPolicyWebsite,
    stickerPack.licenseAgreementWebsite,
    stickerPack.animatedStickerPack ?? false,
    stickers,
  );
}
