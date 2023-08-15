import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:sticker_dev/widgets/sticker_pack_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StickersScreen extends StatefulWidget {
  const StickersScreen({Key? key}) : super(key: key);

  @override
  State<StickersScreen> createState() => _StickersScreenState();
}

class _StickersScreenState extends State<StickersScreen> {
  bool _isLoading = false;
  late List<StickerPack> _stickerPacks;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadStickers();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _refreshStickers() async {
    _loadStickers();
  }

  Future<void> _searchStickers(String? search) async {
    await _loadStickers(search: search);
  }

  Future<void> _loadStickers({String? search}) async {
    setState(() {
      _isLoading = true;
    });
    var query = Supabase.instance.client
        .from('sticker_packs')
        .select<List<Map<String, dynamic>>>('*, stickers(*)');
    if (search != null) {
      query = query.ilike('name', "%${search}%");
    }

    var allData =
        await query.then((value) => value.map(StickerPack.fromMap).toList());

    setState(() {
      _stickerPacks = allData;
      _isLoading = false;
    });
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
            onPressed: () => _searchStickers("paand"),
          ),
        ],
      ),
      body: Column(children: [
        RefreshIndicator(
            onRefresh: _refreshStickers,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator()) // TODO Add skeleton
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _stickerPacks.length,
                    itemBuilder: (context, index) => StickerPackItem(
                          stickerPack: _stickerPacks[index],
                        )))
      ]),
    );
  }
}
