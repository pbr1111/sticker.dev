import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sticker_dev/constants/constants.dart';
import 'package:whatsapp_stickers_handler/exceptions.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:sticker_dev/models/sticker_data.dart';

class StickerPackInfoScreen extends StatefulWidget {
  final StickerPacks stickerPack;

  const StickerPackInfoScreen({Key? key, required this.stickerPack})
      : super(key: key);

  @override
  State<StickerPackInfoScreen> createState() => _StickerPackInfoScreenState();
}

class _StickerPackInfoScreenState extends State<StickerPackInfoScreen> {
  Future<void> addStickerPack() async {}

  @override
  Widget build(BuildContext context) {
    Widget depInstallWidget;

    if (widget.stickerPack.isInstalled) {
      depInstallWidget = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          AppLocalizations.of(context)!.sticker_added,
          style: TextStyle(
              color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      depInstallWidget = ElevatedButton(
        child: Text(AppLocalizations.of(context)!.add_sticker),
        onPressed: () async {
          Map<String, List<String>> stickers = <String, List<String>>{};
          var tryImage = '';
          final dio = Dio();
          final downloads = <Future>[];
          var applicationDocumentsDirectory =
              await getApplicationDocumentsDirectory();
          var stickersDirectory = Directory(
              //'${applicationDocumentsDirectory.path}/stickers/${widget.stickerPack.identifier}');
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
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(exceptionMessage.toString())));
          } catch (e) {
            print("Exception ${e.toString()}");
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stickerPack.name.toString()),
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image(
                    image: NetworkImage(
                        "${BASE_URL}/${widget.stickerPack.identifier}/${widget.stickerPack.trayImageFile}"),
                    height: 100,
                    width: 100,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stickerPack.publisher as String,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    depInstallWidget,
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
              ),
              itemCount: widget.stickerPack.stickers!.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image(
                      image: NetworkImage(
                          "${BASE_URL}${widget.stickerPack.identifier}/${widget.stickerPack.stickers![index].imageFile as String}"),
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
