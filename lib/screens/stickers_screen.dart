import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sticker_dev/models/sticker_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_localizations.dart';
import '../widgets/sticker_pack_item.dart';
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
    await Future.delayed(Duration(seconds: 2));
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
                          expandedHeight: kToolbarHeight * 2,
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
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                        baseColor: Theme.of(context).focusColor,
                                        highlightColor:
                                            Theme.of(context).hoverColor,
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 19, horizontal: 16),
                                            child: Row(children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                margin:
                                                    EdgeInsets.only(right: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 140,
                                                      height: 16,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 160,
                                                      height: 14,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ]),
                                            ])));
                                  },
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) =>
                                      StickerPackItem(
                                        stickerPack: snapshot.data![index],
                                      )))),
                  Container(),
                  Container(),
                ]))));
  }
}
