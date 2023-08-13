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
  final Dio dio = Dio(BaseOptions(baseUrl: BASE_URL));

  Future<void> _loadStickers() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 5));
    var data = await dio.get("contents.json");
    setState(() {
      stickerData = StickerData.fromJson(jsonDecode(data.toString()));
      _isLoading = false;
    });
  }

  @override
  initState() async {
    super.initState();
    await _loadStickers();
  }

  Future<void> _refreshStickers() async {
    _loadStickers();
  }

  void _searchStickers() {}

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
      body: RefreshIndicator(
          onRefresh: _refreshStickers,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator()) // TODO Add skeleton
              : ListView.builder(
                  itemCount: stickerData.stickerPacks!.length,
                  itemBuilder: (context, index) => StickerPackItem(
                        stickerPack: stickerData.stickerPacks![index],
                      ))),
    );
  }
}
