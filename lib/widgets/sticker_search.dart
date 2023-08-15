import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_localizations.dart';

class StickerSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StickerSearchState();
}

class _StickerSearchState extends State<StickerSearch> {
  Future<List<dynamic>> _searchStickers(String search) async {
    var query = Supabase.instance.client
        .from('sticker_packs')
        .select('name')
        .ilike('name', "%${search}%");

    var response = await query
        .then((value) => value.map((v) => v['name'] as String).toList());
    print(response);
    return response;
  }

  Widget build(BuildContext context) {
    return SearchAnchor(
        builder: (context, controller) => SearchBar(
              focusNode: AlwaysDisabledFocusNode(),
              hintText: AppLocalizations.of(context)!.search,
              leading: const Icon(Icons.search),
              onTap: () {
                controller.openView();
              },
            ),
        suggestionsBuilder:
            (BuildContext context, SearchController controller) => [
                  FutureBuilder(
                      future: _searchStickers(controller.text),
                      builder: (context, snapshot) => !snapshot.hasData ||
                              snapshot.connectionState != ConnectionState.done
                          ? const CircularProgressIndicator()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) =>
                                  Text(snapshot.data![index])))
                ]);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
