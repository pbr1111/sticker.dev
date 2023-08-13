import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:sticker_dev/constants/constants.dart';
import 'package:whatsapp_stickers_handler/exceptions.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../widgets/sticker.dart';

class StickerPackDetailScreen extends StatefulWidget {
  final StickerPacks stickerPack;

  const StickerPackDetailScreen({Key? key, required this.stickerPack})
      : super(key: key);

  @override
  State<StickerPackDetailScreen> createState() =>
      _StickerPackDetailScreenState();
}

class _StickerPackDetailScreenState extends State<StickerPackDetailScreen> {
  Future<void> _addPackToWhatsApp() async {
    Map<String, List<String>> stickers = <String, List<String>>{};
    var tryImage = '';
    final dio = Dio();
    final downloads = <Future>[];
    var applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    var stickersDirectory = Directory(
        '${applicationDocumentsDirectory.path}/${widget.stickerPack.identifier}');
    await stickersDirectory.create(recursive: true);

    downloads.add(
      dio.download(
        "${BASE_URL}${widget.stickerPack.identifier}/${widget.stickerPack.trayImageFile}",
        "${stickersDirectory.path}/${widget.stickerPack.trayImageFile!.toLowerCase()}",
      ),
    );
    tryImage = WhatsappStickerImageHandler.fromFile(
            "${stickersDirectory.path}/${widget.stickerPack.trayImageFile!.toLowerCase()}")
        .path;

    for (var e in widget.stickerPack.stickers!) {
      var urlPath =
          "${BASE_URL}${widget.stickerPack.identifier}/${(e.imageFile as String)}";
      var savePath =
          "${stickersDirectory.path}/${(e.imageFile as String).toLowerCase()}";
      downloads.add(
        dio.download(
          urlPath,
          savePath,
        ),
      );

      stickers[WhatsappStickerImageHandler.fromFile(
              "${stickersDirectory.path}/${(e.imageFile as String).toLowerCase()}")
          .path] = e.emojis as List<String>;
    }

    await Future.wait(downloads);

    try {
      final WhatsappStickersHandler _whatsappStickersHandler =
          WhatsappStickersHandler();
      var result = await _whatsappStickersHandler.addStickerPack(
        widget.stickerPack.identifier,
        widget.stickerPack.name as String,
        widget.stickerPack.publisher as String,
        tryImage,
        widget.stickerPack.publisherWebsite,
        widget.stickerPack.privacyPolicyWebsite,
        widget.stickerPack.licenseAgreementWebsite,
        widget.stickerPack.animatedStickerPack ?? false,
        stickers,
      );
      print("RESULT $result");
    } on WhatsappStickersException catch (e) {
      print("INSIDE WhatsappStickersException ${e.cause}");
      var exceptionMessage = e.cause;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(exceptionMessage.toString())));
    } catch (e) {
      print("Exception ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            // pinned: true,
            floating: false,
            title: Text(
              widget.stickerPack.name!,
              overflow: TextOverflow.ellipsis,
            ),
            leading: BackButton(),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Sticker(
                      size: 100,
                      imageUrl:
                          "${BASE_URL}${widget.stickerPack.identifier}/${widget.stickerPack.stickers![index].imageFile as String}"),
                ),
              ),
              childCount: widget.stickerPack.stickers!.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPackToWhatsApp,
        label: Text(AppLocalizations.of(context)!.add_sticker_pack),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
