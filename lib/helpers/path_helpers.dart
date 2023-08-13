import '../constants/constants.dart';
import '../models/sticker_data.dart';

String getStickerImageUrl(StickerPack stickerPack, Sticker sticker) {
  return "${BASE_URL}/${stickerPack.identifier}/${(sticker.imageFile as String)}";
}

String getStickerTrayUrl(StickerPack stickerPack) {
  return "${BASE_URL}/${stickerPack.identifier}/${(stickerPack.trayImageFile as String)}";
}
