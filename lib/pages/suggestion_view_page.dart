import 'package:flutter/material.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/widgets/suggestion_item.dart';

class SuggestionViewPage extends StatefulWidget {
  const SuggestionViewPage({super.key});

  @override
  State<SuggestionViewPage> createState() => _SuggestionViewPageState();
}

class _SuggestionViewPageState extends State<SuggestionViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Просмотр предложений'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: allSuggestions
              .map((Suggestion s) => SuggestionItem(
                    suggestion: s,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
