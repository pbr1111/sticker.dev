import 'package:flutter/material.dart';
import 'package:sticker_dev/helpers/whatsapp_helpers.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:sticker_dev/constants/constants.dart';
import 'package:whatsapp_stickers_handler/exceptions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/sticker_image.dart';

class StickerPackDetailScreen extends StatefulWidget {
  final StickerPack stickerPack;

  const StickerPackDetailScreen({Key? key, required this.stickerPack})
      : super(key: key);

  @override
  State<StickerPackDetailScreen> createState() =>
      _StickerPackDetailScreenState();
}

class _StickerPackDetailScreenState extends State<StickerPackDetailScreen> {
  Future<void> _addPackToWhatsApp() async {
    try {
      await addPackToWhatsApp(widget.stickerPack);
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
            pinned: true,
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
                  child: StickerImage(
                      size: 100,
                      imageUrl:
                          "${BASE_URL}/${widget.stickerPack.identifier}/${widget.stickerPack.stickers![index].imageFile as String}"),
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
