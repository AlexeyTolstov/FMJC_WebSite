import 'package:flutter/material.dart';

class SuggestionViewPage extends StatefulWidget {
  const SuggestionViewPage({super.key});

  @override
  State<SuggestionViewPage> createState() => _SuggestionViewPageState();
}

class _SuggestionViewPageState extends State<SuggestionViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Просмотр предложений'),
      ),
    );
  }
}
