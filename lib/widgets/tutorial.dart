import 'package:flutter/material.dart';

class Lesson {
  final String title;
  final String description;

  Lesson({required this.title, required this.description});
}

class Tutorial {
  final BuildContext context;
  Tutorial(this.context);

  void showTutorialDialog() {
    _showDialog(
      title: "Добро пожаловать!",
      content: "Хотите пройти небольшое обучение по использованию приложения?",
      actions: [
        _dialogButton("Нет, я все знаю", () => Navigator.pop(context)),
        _dialogButton("Да", () {
          _showStep(0);
        }),
      ],
    );
  }

  final List<String> steps = [
    "На карте отмечены красные маркеры — это предложения пользователей. Нажмите на них, чтобы просмотреть детали и оставить свою оценку.",
    "Чтобы добавить свою точку с предложением, просто коснитесь нужного места, введите текст — и всё готово!",
    "Хотите предложить или изучить идеи, создать маршрут? Вверху справа находится меню — откройте его, и получите доступ ко всем возможностям.",
    "Спасибо, что установили Альфа-версию! Мы ценим ваш интерес!",
  ];

  void _showStep(int stepIndex) {
    _showDialog(
      title: "Обучение",
      content: steps[stepIndex],
      actions: [
        if (stepIndex > 0)
          _dialogButton("<- Назад", () => _showStep(stepIndex - 1)),
        if (stepIndex < steps.length - 1)
          _dialogButton("Дальше ->", () => _showStep(stepIndex + 1))
        else
          _dialogButton("Завершить!", () {}),
      ],
      backgroundColor: Colors.transparent,
      textColor: Colors.white,
    );
  }

  void _showDialog({
    required String title,
    required String content,
    required List<Widget> actions,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(title, style: TextStyle(color: textColor)),
        content: Container(
          padding: EdgeInsets.all(20),
          child: Text(
            content,
            style: TextStyle(color: textColor, fontSize: 17),
          ),
        ),
        actions: actions,
      ),
    );
  }

  TextButton _dialogButton(String text, VoidCallback onPressed) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
        onPressed();
      },
      child: Text(text),
    );
  }
}
