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
      height: 150,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(15)),
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
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.thumb_up_outlined),
                        Text(' 10'),
                      ],
                    ),
                    SizedBox(width: 30),
                    Row(
                      children: [
                        Icon(Icons.thumb_down_outlined),
                        Text(' 12'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
