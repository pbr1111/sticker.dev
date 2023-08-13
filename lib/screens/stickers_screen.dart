import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:sticker_dev/widgets/sticker_pack_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/constants.dart';

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
  late Dio dio;
  var downloads = <Future>[];
  var data;

  void _loadStickers() async {
    dio = Dio();
    data = await dio.get("${BASE_URL}contents.json");
    setState(() {
      stickerData = StickerData.fromJson(jsonDecode(data.toString()));
      _isLoading = false;
    });
  }

  @override
  didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    _loadStickers();
    super.didChangeDependencies();
  }

  void _searchStickers() {}

  Future<void> _pullRefresh() async {
    _loadStickers();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: AppLocalizations.of(context)!.search,
            onPressed: _searchStickers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView.builder(
                  itemCount: stickerData.stickerPacks!.length,
                  itemBuilder: (context, index) => StickerPackItem(
                        stickerPack: stickerData.stickerPacks![index],
                      ))),
    );
  }
}
