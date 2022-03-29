import 'dart:async';

import 'package:flutter/material.dart';

enum SearchType { ON_COMPLETE, ON_CHANGED }

class SearchBar extends StatefulWidget {
  final String textSearch;
  final SearchType searchType;
  final Function(String text) updateSearchQuery;
  final bool delayed;
  final Duration duration;
  final String searchInit;
  final IconData icon;

  static const String search = "Buscar...";
  static const Duration durationDefault = Duration(milliseconds: 800);

  const SearchBar({
    Key key,
    this.textSearch: search,
    this.searchType: SearchType.ON_CHANGED,
    @required this.updateSearchQuery,
    this.delayed: false,
    this.duration: durationDefault,
    this.searchInit,
    this.icon: Icons.search,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchQuery = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  Map<Function, Timer> _timeouts = {};

  @override
  void initState() {
    super.initState();
    if (widget.searchInit != null) {
      _searchQuery.text = widget.searchInit;
    }

    _searchQuery.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              focusNode: _searchFocusNode,
              controller: _searchQuery,
              autofocus: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                alignLabelWithHint: true,
                prefixIcon: Icon(
                  widget.icon,
                  size: 16,
                ),
                hintText: '${widget.textSearch}',
                hintStyle: TextStyle(fontSize: 13)
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 16.0),
              onEditingComplete: widget.searchType == SearchType.ON_COMPLETE
                  ? () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.updateSearchQuery(_searchQuery.text);
                    }
                  : null,
              onChanged: widget.searchType == SearchType.ON_CHANGED
                  ? (val) => widget.delayed
                      ? debounce(
                          widget.duration, widget.updateSearchQuery, [val])
                      : widget.updateSearchQuery(val)
                  : null,
            ),
          ),
          _searchFocusNode.hasFocus
              ? RawMaterialButton(
                  shape: CircleBorder(),
                  constraints: BoxConstraints.tightFor(
                    width: 36.0,
                    height: 36.0,
                  ),
                  child: const Icon(Icons.cancel),
                  onPressed: () {
                    if (_searchQuery == null || _searchQuery.text.isEmpty) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {});
                      return;
                    }
                    _clearSearchQuery();
                  },
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      widget.updateSearchQuery('');
    });
  }

  void debounce(Duration timeout, Function target, [List arguments = const []]) {
    if (_timeouts.containsKey(target)) {
      _timeouts[target].cancel();
    }

    Timer timer = Timer(timeout, () {
      Function.apply(target, arguments);
    });

    _timeouts[target] = timer;
  }
}
