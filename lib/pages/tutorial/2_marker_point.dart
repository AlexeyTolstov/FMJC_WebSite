import 'package:flutter/material.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/styles/images.dart';

/// Туториал 2: Предложения пользователей
class Tutorial_2 extends StatelessWidget {
  const Tutorial_2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Column(
        children: [
          Text(
            'На карте отмечены красные маркеры — это предложения пользователей.',
            style: TutorialTextStyles.text,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              height: 200,
              image: TutorialImages.suggestionMarkerImage,
            ),
          ),
          Text(
            'Нажмите на них, чтобы просмотреть детали и оставить свою оценку.',
            style: TutorialTextStyles.text,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              height: 400,
              image: TutorialImages.suggestionPanelImage,
            ),
          ),
        ],
      ),
    );
  }
}
