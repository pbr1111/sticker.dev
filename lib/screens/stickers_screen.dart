import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_localizations.dart';
import '../widgets/skeletons/sticker_pack_item_skeleton.dart';
import '../widgets/sticker_pack_item_extended.dart';
import '../widgets/sticker_search.dart';

class StickersScreen extends StatefulWidget {
  const StickersScreen({Key? key}) : super(key: key);

  @override
  State<StickersScreen> createState() => _StickersScreenState();
}

class _StickersScreenState extends State<StickersScreen> {
  Future<void> _refreshStickers() async {
    setState(() {});
  }

  Future<List<StickerPack>> _loadStickers() async {
    var query = Supabase.instance.client
        .from('sticker_packs')
        .select<List<Map<String, dynamic>>>('*, stickers(*)');
    return await query.then((value) => value.map(StickerPack.fromMap).toList());
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 3,
            child: NestedScrollView(
                headerSliverBuilder: (builder, _) => [
                      SliverAppBar(
                          pinned: true,
                          floating: true,
                          title: StickerSearch(),
                          bottom: TabBar(
                            tabs: [
                              Tab(text: AppLocalizations.of(context)!.for_you),
                              Tab(
                                  text: AppLocalizations.of(context)!
                                      .most_popular),
                              Tab(
                                  text:
                                      AppLocalizations.of(context)!.categories),
                            ],
                          ))
                    ],
                body: TabBarView(children: [
                  RefreshIndicator(
                      onRefresh: _refreshStickers,
                      child: FutureBuilder(
                          future: _loadStickers(),
                          builder: (context, snapshot) => !snapshot.hasData ||
                                  snapshot.connectionState !=
                                      ConnectionState.done
                              ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 10,
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) =>
                                      StickerPackItemSkeleton(),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  itemBuilder: (context, index) =>
                                      StickerPackItemExtended(
                                        stickerPack: snapshot.data![index],
                                      )))),
                  Container(),
                  Container(),
                ]))));
  }
}
