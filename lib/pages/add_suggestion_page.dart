import 'package:flutter/material.dart';
import 'package:maps_application/styles/button_styles.dart';

class AddSuggestionPage extends StatefulWidget {
  const AddSuggestionPage({super.key});

  @override
  State<AddSuggestionPage> createState() => _AddSuggestionPageState();
}

class _AddSuggestionPageState extends State<AddSuggestionPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
            Row(
              children: [
                TextButton(
                  style: AppButtonStyles.saveButton,
                  onPressed: () {
                    if (nameController.text.length == 0 ||
                        descriptionController.text.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Поля не должны быть пустыми')));
                      return;
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Сохранить'),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: AppButtonStyles.cancelButton,
                  child: Text(
                    'Отмема',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
