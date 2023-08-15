class StickerPack {
  String identifier;
  String name;
  String publisher;
  String trayImageFile;
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
      required this.imageDataVersion,
      required this.publisherEmail,
      required this.publisherWebsite,
      required this.privacyPolicyWebsite,
      required this.licenseAgreementWebsite,
      required this.stickers,
      this.animatedStickerPack});

  factory StickerPack.fromMap(Map<String, dynamic> data) {
    return StickerPack(
      identifier: data['id'].toString(),
      name: data['name'],
      publisher: data['publisher'],
      trayImageFile: data['tray_image_file'],
      imageDataVersion: data['image_data_version'],
      publisherEmail: data['publisher_email'],
      publisherWebsite: data['publisher_website'],
      privacyPolicyWebsite: data['privacy_policy_website'],
      licenseAgreementWebsite: data['license_agreement_website'],
      stickers:
          List.from(data['stickers']).map((e) => Sticker.fromMap(e)).toList(),
      animatedStickerPack: data['animated_sticker_pack'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier,
      'name': name,
      'publisher': publisher,
      'image_data_version': imageDataVersion,
      'publisher_email': publisherEmail,
      'publisher_website': publisherWebsite,
      'privacy_policy_website': privacyPolicyWebsite,
      'license_agreement_website': licenseAgreementWebsite,
      'stickers': stickers.map((v) => v.toMap()).toList(),
      'animated_sticker_pack': animatedStickerPack,
    };
  }

  @override
  String toString() {
    return "identifier: $identifier, name: $name, publisher: $publisher";
  }
}

class Sticker {
  final String stickerPackId;
  final String imageFile;
  final List<String> emojis;

  Sticker(
      {required this.stickerPackId,
      required this.imageFile,
      required this.emojis});

  factory Sticker.fromMap(Map<String, dynamic> data) {
    return Sticker(
      stickerPackId: data['sticker_pack_id'].toString(),
      imageFile: data['image_file'],
      emojis: List.from(data['emojis']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'image_file': imageFile, 'emojis': emojis};
  }
}
