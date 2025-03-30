import 'package:flutter/material.dart';
import 'package:maps_application/api/search_places.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _controller = TextEditingController();

  /// Params for search

  String _lastText = '';
  bool _isSearching = false;
  List<Places> _searchResult = [];

  void search() {
    if (_controller.text.length < 3 || _isSearching) return;

    if (_lastText != _controller.text) {
      _isSearching = true;
      _lastText = _controller.text;

      print('abc');
      searchPlaces(query: _controller.text).then((List<Places> searchResult) {
        print(searchResult);
        setState(() {
          _searchResult = searchResult;
          _isSearching = false;
        });
      }).onError((e, _) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1000,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: _controller,
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
        Container(
          width: 900,
          child: Column(
            spacing: 5,
            children:
                _searchResult.map((e) => SearchResultItem(data: e)).toList(),
          ),
        ),
      ],
    );
  }
}

class SearchResultItem extends StatelessWidget {
  final Places data;
  const SearchResultItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 900,
      height: 50,
      child: Text(data.toString()),
    );
  }
}
