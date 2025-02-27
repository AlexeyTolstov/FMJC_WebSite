import 'package:flutter/material.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/styles/images.dart';

/// Туториал 1: Маркер положения пользователя
class Tutorial_1 extends StatelessWidget {
  const Tutorial_1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Column(
        children: [
          Text(
            'Если вы разрешили доступ к своему местоположению, на карте появится синий маркер — это вы! \nПолупрозрачный круг вокруг него обозначает примерный радиус вашего местоположения.',
            style: TutorialTextStyles.text,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
                height: 200, image: TutorialImages.userLocationMarkerImage),
          ),
          Text(
            'В нижнем левом углу находится кнопка — нажмите её, чтобы мгновенно вернуться к своему текущему местоположению на карте.',
            style: TutorialTextStyles.text,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Image(image: TutorialImages.targetImage),
          ),
        ],
      ),
    );
  }
}
