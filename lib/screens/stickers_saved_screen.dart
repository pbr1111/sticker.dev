import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StickersSavedScreen extends StatefulWidget {
  const StickersSavedScreen({Key? key}) : super(key: key);

  @override
  State<StickersSavedScreen> createState() => _StickersSavedScreenState();
}

class _StickersSavedScreenState extends State<StickersSavedScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.saved),
        centerTitle: true,
      ),
    );
  }
}
