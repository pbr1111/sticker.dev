import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/search_field.dart';
import '../widgets/sticker_pack_item.dart';

class StickersScreen extends StatefulWidget {
  const StickersScreen({Key? key}) : super(key: key);

  @override
  State<StickersScreen> createState() => _StickersScreenState();
}

class _StickersScreenState extends State<StickersScreen> {
  bool _isLoading = false;
  late List<StickerPack> _stickerPacks;

  @override
  void initState() {
    super.initState();
    _loadStickers();
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
    if (search?.isNotEmpty ?? false) {
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
        body: NestedScrollView(
            headerSliverBuilder: (builder, _) => [
                  SliverAppBar(
                    title: Text(AppLocalizations.of(context)!.title),
                    centerTitle: true,
                    floating: true,
                    pinned: true,
                    snap: true,
                    expandedHeight: 2 * kToolbarHeight,
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, bottom: 6),
                            child: SearchField(onSearch: _searchStickers))),
                  ),
                ],
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
                            )))));
  }
}
