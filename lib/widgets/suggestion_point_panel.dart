import 'package:flutter/material.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/pages/main_page.dart';
import 'package:maps_application/styles/button_styles.dart';

class SuggestionPointPanel extends StatelessWidget {
  final Suggestion suggestion;
  final VoidCallback onClose;
  final bool isEnable;

  const SuggestionPointPanel({
    super.key,
    required this.suggestion,
    required this.onClose,
    required this.isEnable,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    nameController.text = suggestion.name;
    descriptionController.text = suggestion.description;

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
                      enabled: isEnable,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Описание",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 10,
                      enabled: isEnable,
                    ),
                    SizedBox(height: 10),
                    if (!isEnable)
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.favorite_border),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.block),
                          ),
                        ],
                      ),
                    Spacer(),
                    Row(
                      children: [
                        if (isEnable)
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

                                  if (isHaveId(suggestion.id)) {
                                    editSuggestion(
                                      suggestion.id,
                                      name: nameController.text,
                                      description: descriptionController.text,
                                    );
                                  } else {
                                    addSuggestion(Suggestion(
                                      name: nameController.text,
                                      description: descriptionController.text,
                                      author_id: myId,
                                      coords: suggestion.coords,
                                      category: suggestion.category,
                                    ));
                                  }
                                  onClose();
                                },
                                child: Text('Сохранить'),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        TextButton(
                          onPressed: onClose,
                          style: AppButtonStyles.cancelButton,
                          child: Text(
                            (isEnable) ? 'Отмена' : 'Закрыть',
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
