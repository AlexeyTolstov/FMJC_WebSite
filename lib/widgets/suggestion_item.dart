import 'package:flutter/material.dart';
import 'package:maps_application/data/suggestion.dart';

class SuggestionItem extends StatelessWidget {
  final Suggestion suggestion;
  const SuggestionItem({
    super.key,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          Text(
            suggestion.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
