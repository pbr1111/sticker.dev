import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final Function(String? value)? onSearch;
  const SearchField({Key? key, this.onSearch}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _debounce;
  final _textFieldController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String? value) {
    if (widget.onSearch != null) {
      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      }

      _debounce = Timer(const Duration(milliseconds: 500), () {
        widget.onSearch!(value);
      });
    }
  }

  Widget build(BuildContext context) {
    return TextField(
      controller: _textFieldController,
      onChanged: _onSearch,
      decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.search,
          prefixIcon: const Icon(Icons.search),
          prefixIconConstraints: BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          suffixIcon: _textFieldController.value.text.isNotEmpty
              ? SizedBox(
                  height: 40,
                  width: 40,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _textFieldController.clear();
                      widget.onSearch?.call(null);
                    },
                  ))
              : null,
          suffixIconConstraints: BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          isDense: true),
    );
  }
}
