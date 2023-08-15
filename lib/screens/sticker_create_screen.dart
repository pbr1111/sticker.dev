import 'package:flutter/material.dart';

import '../app_localizations.dart';

class StickerCreateScreen extends StatefulWidget {
  const StickerCreateScreen({Key? key}) : super(key: key);

  @override
  State<StickerCreateScreen> createState() => _StickerCreateScreenState();
}

class _StickerCreateScreenState extends State<StickerCreateScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.create),
        centerTitle: true,
      ),
    );
  }
}
