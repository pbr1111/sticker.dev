import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/sticker_data.dart';

String getTrayImageUrl(StickerPack stickerPack) {
  return Supabase.instance.client.storage
      .from('stickers')
      .getPublicUrl("${stickerPack.identifier}/${stickerPack.trayImageFile}");
}

String getStickerImageUrl(Sticker sticker) {
  return Supabase.instance.client.storage
      .from('stickers')
      .getPublicUrl("${sticker.stickerPackId}/${sticker.imageFile}");
}
