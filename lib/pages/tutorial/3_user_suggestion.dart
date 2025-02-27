import 'package:flutter/material.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/styles/images.dart';

/// Туториал 3: Мое предложение
class Tutorial_3 extends StatelessWidget {
  const Tutorial_3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Column(
        children: [
          Text(
            'Чтобы добавить свою точку с предложением, просто коснитесь нужного места, введите текст — и всё готово!',
            style: TutorialTextStyles.text,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              height: 400,
              image: TutorialImages.addSuggestionImage,
            ),
          ),
        ],
      ),
    );
  }
}
