import 'package:flutter/material.dart';
import 'package:maps_application/api/search_places.dart';

class MySearchBar extends StatefulWidget {
  final Function(Place) onSearchItemTap;
  const MySearchBar({
    super.key,
    required this.onSearchItemTap,
  });

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  /// Params for search

  String _lastText = '';
  bool _isSearching = false;
  List<Place> _searchResult = [];

  void search() {
    if (_isSearching) return;
    if (_controller.text.length < 3) {
      setState(() {
        _searchResult = [];
      });
      return;
    }

    if (_lastText != _controller.text) {
      _isSearching = true;
      _lastText = _controller.text;

      searchPlaces(query: _controller.text).then((List<Place> searchResult) {
        setState(() {
          _searchResult = searchResult;
          _isSearching = false;
        });
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      Future.delayed(Duration(milliseconds: 300)).then((e) => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: _controller,
            focusNode: _focusNode,
            onChanged: (_) {
              search();
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(25),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: search,
              ),
              fillColor: const Color.fromARGB(255, 224, 224, 224),
              iconColor: Colors.red,
              filled: true,
              hintText: 'Поиск мест...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(width: 0, color: Colors.red),
              ),
            ),
          ),
        ),
        if (_focusNode.hasFocus)
          Container(
            child: Column(
              spacing: 5,
              children: _searchResult
                  .map(
                    (e) => SearchResultItem(
                      data: e,
                      onTap: () => widget.onSearchItemTap(e),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class SearchResultItem extends StatelessWidget {
  final Place data;
  final VoidCallback onTap;

  const SearchResultItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 50,
        child: Text(data.toString()),
      ),
    );
  }
}
