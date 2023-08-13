import 'package:flutter/material.dart';
import 'package:sticker_dev/screens/information_screen.dart';
import 'package:sticker_dev/screens/sticker_pack_info.dart';
import 'package:sticker_dev/screens/stickers_screen.dart';

enum PopupMenuOptions {
  staticStickers,
  remoteStickers,
  informations,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sticker.dev",
      initialRoute: StickersScreen.routeName,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green[700]),
      debugShowCheckedModeBanner: false,
      routes: {
        StickersScreen.routeName: (ctx) => const StickersScreen(),
        StickerPackInfoScreen.routeName: (ctx) => const StickerPackInfoScreen(),
        InformationScreen.routeName: (ctx) => const InformationScreen()
      },
    );
  }
}
