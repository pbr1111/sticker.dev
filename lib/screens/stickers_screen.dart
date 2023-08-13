import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sticker_dev/constants/constants.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:dio/dio.dart';
import 'package:sticker_dev/widgets/sticker_pack_item.dart';

class StickersScreen extends StatefulWidget {
  const StickersScreen({Key? key}) : super(key: key);

  @override
  State<StickersScreen> createState() => _StickersScreenState();
}

class _StickersScreenState extends State<StickersScreen> {
  bool _isLoading = false;

  late StickerData stickerData;

  List stickerPacks = [];
  List installedStickerPacks = [];
  late String stickerFetchType;
  late Dio dio;
  var downloads = <Future>[];
  var data;

  void _loadStickers() async {
    if (stickerFetchType == 'staticStickers') {
      data = await rootBundle.loadString("sticker_packs/sticker_packs.json");
    } else {
      dio = Dio();
      data = await dio.get("${BASE_URL}contents.json");
    }
    setState(() {
      stickerData = StickerData.fromJson(jsonDecode(data.toString()));
      _isLoading = false;
    });
  }

  @override
  didChangeDependencies() {
    var args = ModalRoute.of(context)?.settings.arguments as String?;
    stickerFetchType = args ?? "staticStickers";
    setState(() {
      _isLoading = true;
    });
    _loadStickers();
    super.didChangeDependencies();
  }

  void _searchStickers() {}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sticker.dev"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            tooltip: 'Search',
            onPressed: _searchStickers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: stickerData.stickerPacks!.length,
              itemBuilder: (context, index) => StickerPackItem(
                    stickerPack: stickerData.stickerPacks![index],
                    stickerFetchType: stickerFetchType,
                  )),
    );
  }
}
