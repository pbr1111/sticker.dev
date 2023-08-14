import 'package:firebase_storage/firebase_storage.dart';

String getStickerImageUrl(String relativePath) {
  return "https://storage.googleapis.com/${FirebaseStorage.instance.bucket}/${relativePath}";
}
