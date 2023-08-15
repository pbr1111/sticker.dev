import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sticker_dev/widgets/sticker_pack_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_localizations.dart';
import '../models/sticker_data.dart';

class StickerSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StickerSearchState();
}

class _StickerSearchState extends State<StickerSearch> {
  Future<List<StickerPack>> _searchStickers(String search) async {
    if (search.isEmpty) return [];

    var query = Supabase.instance.client
        .from('sticker_packs')
        .select<List<Map<String, dynamic>>>('*, stickers(*)')
        .ilike('name', "%${search}%");

    var response =
        await query.then((value) => value.map(StickerPack.fromMap).toList());
    return response;
  }

  Widget build(BuildContext context) {
    return SearchAnchor(
        viewHintText: AppLocalizations.of(context)!.search,
        builder: (context, controller) => SearchBar(
              focusNode: AlwaysDisabledFocusNode(),
              hintText: AppLocalizations.of(context)!.search,
              leading: const Icon(Icons.search),
              onTap: () {
                controller.openView();
              },
              elevation: MaterialStateProperty.all(3),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              constraints: BoxConstraints(maxHeight: 56),
              padding: MaterialStateProperty.all(
                  EdgeInsets.only(left: 16, right: 6)),
              trailing: [
                IconButton(
                    iconSize: 30,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: const Icon(Icons.account_circle),
                    tooltip: AppLocalizations.of(context)!.profile,
                    onPressed: () {})
              ],
            ),
        suggestionsBuilder:
            (BuildContext context, SearchController controller) => [
                  FutureBuilder(
                      future: _searchStickers(controller.text),
                      builder: (context, snapshot) => !snapshot.hasData ||
                              snapshot.connectionState != ConnectionState.done
                          ? Center(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32),
                                  child: const CircularProgressIndicator()))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) => StickerPackItem(
                                  stickerPack: snapshot.data![index])))
                ]);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
