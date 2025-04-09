import 'package:flutter/material.dart';
import 'package:maps_application/api/suggestion/get_suggestion_list.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/user_service.dart';
import 'package:maps_application/widgets/suggestion_item.dart';

class SuggestionViewPage extends StatefulWidget {
  const SuggestionViewPage({super.key});

  @override
  State<SuggestionViewPage> createState() => _SuggestionViewPageState();
}

class _SuggestionViewPageState extends State<SuggestionViewPage> {
  List<Suggestion>? _listSuggestion;

  @override
  void initState() {
    get_all_suggestion().then((v) {
      setState(() {
        _listSuggestion = v;
      });
    });

    super.initState();
  }

  void onSearch(bool isPoint, bool isRoute, bool isProposal) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Просмотр предложений'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
            ),
            FiltersSearchBar(
              onSearch: (
                bool isPoint,
                bool isRoute,
                bool isProposal,
                bool isUser,
              ) {
                get_all_suggestion(
                  id: (isUser) ? int.parse(UserService().userId!) : null,
                  isPoint: isPoint,
                  isRoute: isRoute,
                  isProposal: isProposal,
                ).then((v) {
                  setState(() {
                    _listSuggestion = v;
                  });
                });
              },
            ),
            if (_listSuggestion == null)
              Text('Идет загрузка предложений')
            else if (_listSuggestion!.length == 0)
              Text('Предложений нет')
            else
              ..._listSuggestion!.map((Suggestion s) => SuggestionItem(
                    suggestion: s,
                  )),
          ],
        ),
      ),
    );
  }
}

class FiltersSearchBar extends StatefulWidget {
  const FiltersSearchBar({super.key, required this.onSearch});
  final Function(bool, bool, bool, bool) onSearch;
  @override
  State<FiltersSearchBar> createState() => _FiltersSearchBarState();
}

class _FiltersSearchBarState extends State<FiltersSearchBar> {
  final TextEditingController controller = TextEditingController();

  bool a = false;
  bool b = false;
  bool c = false;
  bool d = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Фильтры предложений',
            style: MainTextStyles.title,
          ),
          SizedBox(height: 5),
          Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: a,
                    onChanged: (value) {
                      setState(() {
                        a = !a;
                      });
                    },
                  ),
                  Text('Предложения с точкой'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: b,
                    onChanged: (value) {
                      setState(() {
                        b = !b;
                      });
                    },
                  ),
                  Text('Предложения с маршрутом'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: c,
                    onChanged: (value) {
                      setState(() {
                        c = !c;
                      });
                    },
                  ),
                  Text('Текстовые предложения'),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              widget.onSearch(a, b, c, d);
            },
            child: Text('Применить фильтры'),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  d = !d;
                });
              },
              style: ButtonStyle(
                  backgroundColor: (!d)
                      ? WidgetStatePropertyAll(Colors.white)
                      : WidgetStatePropertyAll(Colors.blue),
                  foregroundColor: (!d)
                      ? WidgetStatePropertyAll(Colors.blue)
                      : WidgetStatePropertyAll(Colors.white)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.person), Text('Мои предложения')],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: controller,
                maxLines: 1,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/suggestion-view/${controller.text}');
                    },
                  ),
                  hintText: 'ID предложения',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
