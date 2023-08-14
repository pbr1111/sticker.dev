import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:sticker_dev/widgets/sticker_pack_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StickersScreen extends StatefulWidget {
  const StickersScreen({Key? key}) : super(key: key);

  @override
  State<StickersScreen> createState() => _StickersScreenState();
}

class _StickersScreenState extends State<StickersScreen> {
  final _collectionRef = FirebaseFirestore.instance.collection("sticker_packs");
  bool _isLoading = false;
  late List<StickerPack> _stickerPacks;

  Future<void> _loadStickers() async {
    setState(() {
      _isLoading = true;
    });
    var querySnapshot = await _collectionRef.get();
    var allData = querySnapshot.docs
        .map((doc) => StickerPack.fromFirestore(doc))
        .toList();
    setState(() {
      _stickerPacks = allData;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStickers();
  }

  Future<void> _refreshStickers() async {
    // await DefaultCacheManager().removeFile(CONTENT_DATA_PATH);
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
                  shrinkWrap: true,
                  itemCount: _stickerPacks.length,
                  itemBuilder: (context, index) => StickerPackItem(
                        stickerPack: _stickerPacks[index],
                      ))),
    );
  }
}
