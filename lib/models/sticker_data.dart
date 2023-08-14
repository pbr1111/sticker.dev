import 'package:cloud_firestore/cloud_firestore.dart';

class StickerPack {
  String identifier;
  String name;
  String publisher;
  String trayImageFile;
  String trayImageRef;
  String imageDataVersion;
  String publisherEmail;
  String publisherWebsite;
  String privacyPolicyWebsite;
  String licenseAgreementWebsite;
  List<Sticker> stickers = [];
  bool? animatedStickerPack;
  bool isInstalled = false;

  StickerPack(
      {required this.identifier,
      required this.name,
      required this.publisher,
      required this.trayImageFile,
      required this.trayImageRef,
      required this.imageDataVersion,
      required this.publisherEmail,
      required this.publisherWebsite,
      required this.privacyPolicyWebsite,
      required this.licenseAgreementWebsite,
      required this.stickers,
      this.animatedStickerPack});

  factory StickerPack.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return StickerPack(
      identifier: snapshot.reference.id,
      name: data!['name'],
      publisher: data['publisher'],
      trayImageFile: data['tray_image_file'],
      trayImageRef: data['tray_image_ref'],
      imageDataVersion: data['image_data_version'],
      publisherEmail: data['publisher_email'],
      publisherWebsite: data['publisher_website'],
      privacyPolicyWebsite: data['privacy_policy_website'],
      licenseAgreementWebsite: data['license_agreement_website'],
      stickers: List.from(data['stickers'])
          .map((e) => Sticker.fromFirestore(e))
          .toList(),
      animatedStickerPack: data['animated_sticker_pack'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'identifier': identifier,
      'name': name,
      'publisher': publisher,
      'tray_image_file': trayImageRef,
      'image_data_version': imageDataVersion,
      'publisher_email': publisherEmail,
      'publisher_website': publisherWebsite,
      'privacy_policy_website': privacyPolicyWebsite,
      'license_agreement_website': licenseAgreementWebsite,
      'stickers': stickers.map((v) => v.toFirestore()).toList(),
      'animated_sticker_pack': animatedStickerPack,
    };
  }

  @override
  String toString() {
    return "identifier: $identifier, name: $name, publisher: $publisher";
  }
}

class Sticker {
  final String imageFile;
  final String imageRef;
  final List<String> emojis;

  Sticker(
      {required this.imageFile, required this.imageRef, required this.emojis});

  factory Sticker.fromFirestore(Map<String, dynamic> data) {
    return Sticker(
      imageFile: data['image_file'],
      imageRef: data['image_ref'],
      emojis: List.from(data['emojis']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'image_file': imageFile, 'emojis': emojis};
  }
}
