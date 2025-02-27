import 'package:flutter/material.dart';
import 'package:maps_application/pages/tutorial/1_location_marker.dart';
import 'package:maps_application/pages/tutorial/2_marker_point.dart';
import 'package:maps_application/pages/tutorial/3_user_suggestion.dart';
import 'package:maps_application/styles/button_styles.dart';
import 'package:maps_application/styles/font_styles.dart';

class Lesson {
  final Widget? titleWidget;
  final Widget? bodyWidget;

  Lesson({
    this.titleWidget,
    this.bodyWidget,
  });
}

class Tutorial {
  final BuildContext context;
  int indexTutorial = 0;

  Tutorial(this.context);

  void startDialog() {
    _showDialog(
      titleWidget: Text(
        'Добро пожаловать!',
        style: TutorialTextStyles.title,
      ),
      bodyWidget: Text(
        'Хотите небольшое обучение?',
        style: TutorialTextStyles.text,
      ),
      actions: [
        TextButton(
          style: TutorialButtonStyles.actionButton,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Нет, я все знаю'),
        ),
        TextButton(
          style: TutorialButtonStyles.actionButton,
          onPressed: () {
            Navigator.pop(context);
            _showDialog(
              titleWidget: steps.first.titleWidget,
              bodyWidget: steps.first.bodyWidget,
              actions: actionsButtons(),
            );
          },
          child: Text('Да'),
        ),
      ],
    );
  }

  final List<Lesson> steps = [
    Lesson(
      titleWidget: const Text(
        'Обучение',
        style: TutorialTextStyles.title,
      ),
      bodyWidget: Tutorial_1(),
    ),
    Lesson(
      titleWidget: const Text(
        'Обучение',
        style: TutorialTextStyles.title,
      ),
      bodyWidget: Tutorial_2(),
    ),
    Lesson(
      titleWidget: const Text(
        'Обучение',
        style: TutorialTextStyles.title,
      ),
      bodyWidget: Tutorial_3(),
    ),
    Lesson(
      titleWidget: const Text(
        'Обучение',
        style: TutorialTextStyles.title,
      ),
      bodyWidget: Text(
        'Спасибо, что запустили альфа-версию',
        style: TutorialTextStyles.text,
      ),
    ),
  ];

  void _showDialog({
    Widget? titleWidget,
    Widget? bodyWidget,
    List<Widget>? actions,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        title: titleWidget,
        content: SingleChildScrollView(child: bodyWidget),
        actions: actions,
      ),
    );
  }

  List<Widget> actionsButtons() {
    List<Widget> actions = [];
    if (indexTutorial != 0)
      actions.add(
        TextButton(
          style: TutorialButtonStyles.actionButton,
          onPressed: () {
            Navigator.pop(context);
            indexTutorial--;
            _showDialog(
              titleWidget: steps[indexTutorial].titleWidget,
              bodyWidget: steps[indexTutorial].bodyWidget,
              actions: actionsButtons(),
            );
          },
          child: Text('<- Назад'),
        ),
      );

    if (indexTutorial == steps.length - 1)
      actions.add(
        TextButton(
          style: TutorialButtonStyles.actionButton,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Завершить'),
        ),
      );
    else
      actions.add(
        TextButton(
          style: TutorialButtonStyles.actionButton,
          onPressed: () {
            Navigator.pop(context);
            indexTutorial++;
            _showDialog(
              titleWidget: steps[indexTutorial].titleWidget,
              bodyWidget: steps[indexTutorial].bodyWidget,
              actions: actionsButtons(),
            );
          },
          child: Text('Дальше ->'),
        ),
      );

    return actions;
  }
}
