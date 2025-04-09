import 'package:flutter/material.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/styles/font_styles.dart';

class SuggestionItem extends StatelessWidget {
  final Suggestion suggestion;
  const SuggestionItem({
    super.key,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/suggestion-view/${suggestion.id}');
      },
      child: Container(
        width: 500,
        height: 175,
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
              style: SuggestionItemTextStyles.title,
            ),
            Text(
              suggestion.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: SuggestionItemTextStyles.description,
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
                          Text(
                            ' ${suggestion.likes ?? 0}',
                            style: SuggestionItemTextStyles.score,
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      Row(
                        children: [
                          Icon(Icons.thumb_down_outlined),
                          Text(
                            ' ${suggestion.dislikes ?? 0}',
                            style: SuggestionItemTextStyles.score,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
