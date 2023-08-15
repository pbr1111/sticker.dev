import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
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
  String? _search;

  Future<void> _searchStickers(String? search) async {
    setState(() {
      _search = search;
    });
  }

  Future<void> _refreshStickers() async {
    setState(() {});
  }

  Future<List<StickerPack>> _loadStickers() async {
    await Future.delayed(Duration(seconds: 2));
    var query = Supabase.instance.client
        .from('sticker_packs')
        .select<List<Map<String, dynamic>>>('*, stickers(*)');
    if (_search?.isNotEmpty ?? false) {
      query = query.ilike('name', "%${_search}%");
    }
    return await query.then((value) => value.map(StickerPack.fromMap).toList());
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
                child: FutureBuilder(
                    future: _loadStickers(),
                    builder: (context, snapshot) => !snapshot.hasData ||
                            snapshot.connectionState != ConnectionState.done
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                  baseColor: Theme.of(context).focusColor,
                                  highlightColor: Theme.of(context).hoverColor,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 19,
                                          bottom: 19,
                                          right: 16,
                                          left: 16),
                                      child: Row(children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          margin: EdgeInsets.only(right: 12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
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
                                                margin: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Container(
                                                width: 160,
                                                height: 14,
                                                margin: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
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
                            itemBuilder: (context, index) => StickerPackItem(
                                  stickerPack: snapshot.data![index],
                                ))))));
  }
}
