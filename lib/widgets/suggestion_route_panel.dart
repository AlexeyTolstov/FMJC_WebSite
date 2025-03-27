import 'package:flutter/material.dart';
import 'package:maps_application/styles/button_styles.dart';

class SuggestionRoutePanel extends StatelessWidget {
  final VoidCallback onClose;

  SuggestionRoutePanel({super.key, required this.onClose});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
          onPanUpdate: (_) {},
          onTap: onClose,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              width: 400,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Название",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Описание",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 10,
                    ),
                    SizedBox(height: 10),
                    Spacer(),
                    Row(
                      children: [
                        Row(
                          children: [
                            TextButton(
                              style: AppButtonStyles.saveButton,
                              onPressed: () {
                                if (nameController.text.length == 0 ||
                                    descriptionController.text.length == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Поля не должны быть пустыми'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }
                                Navigator.pop(context);
                              },
                              child: Text('Сохранить'),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            onClose();
                            Navigator.pop(context);
                          },
                          style: AppButtonStyles.cancelButton,
                          child: Text(
                            'Закрыть',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
