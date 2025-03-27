import 'package:flutter/material.dart';
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
      body: Center(
        child: Column(
          children: [
            SuggestionItem(),
          ],
        ),
      ),
    );
  }
}
