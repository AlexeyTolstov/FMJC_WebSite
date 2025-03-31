import 'package:flutter/material.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/pages/main_page.dart';
import 'package:maps_application/styles/button_styles.dart';

class SuggestionPointPanel extends StatefulWidget {
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
  State<SuggestionPointPanel> createState() => _SuggestionPointPanelState();
}

class _SuggestionPointPanelState extends State<SuggestionPointPanel> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final int likes = 10;
  final int dislikes = 1;

  String? errorTextName;
  String? errorTextDescription;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.suggestion.name;
    descriptionController.text = widget.suggestion.description;
  }

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
          onTap: widget.onClose,
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
              height: 530,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Название",
                        border: OutlineInputBorder(),
                        labelText: 'Название идеи',
                        errorText: errorTextName,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      maxLength: 100,
                      readOnly: !widget.isEnable,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Описание",
                        border: OutlineInputBorder(),
                        labelText: 'Описание идеи',
                        errorText: errorTextDescription,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      maxLength: 500,
                      maxLines: 10,
                      readOnly: !widget.isEnable,
                    ),
                    SizedBox(height: 10),
                    if (!widget.isEnable)
                      Row(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.thumb_up_outlined),
                              ),
                              Text(likes.toString()),
                            ],
                          ),
                          SizedBox(width: 30),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.thumb_down_outlined),
                              ),
                              Text(dislikes.toString()),
                            ],
                          ),
                        ],
                      ),
                    Spacer(),
                    Row(
                      children: [
                        if (widget.isEnable)
                          Row(
                            children: [
                              TextButton(
                                style: AppButtonStyles.saveButton,
                                onPressed: () {
                                  if (nameController.text.length == 0 ||
                                      descriptionController.text.length == 0) {
                                    setState(() {
                                      if (nameController.text.length == 0)
                                        errorTextName =
                                            'Поле не должно быть пустым';
                                      else
                                        errorTextName = null;
                                      if (descriptionController.text.length ==
                                          0)
                                        errorTextDescription =
                                            'Поле не должно быть пустым';
                                      else
                                        errorTextDescription = null;
                                    });
                                    return;
                                  }

                                  if (isHaveId(widget.suggestion.id)) {
                                    editSuggestion(
                                      widget.suggestion.id,
                                      name: nameController.text,
                                      description: descriptionController.text,
                                    );
                                  } else {
                                    addSuggestion(Suggestion(
                                      name: nameController.text,
                                      description: descriptionController.text,
                                      author_id: myId,
                                      coords: widget.suggestion.coords,
                                      category: widget.suggestion.category,
                                    ));
                                  }
                                  widget.onClose();
                                },
                                child: Text('Сохранить'),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        TextButton(
                          onPressed: widget.onClose,
                          style: AppButtonStyles.cancelButton,
                          child: Text(
                            (widget.isEnable) ? 'Отмена' : 'Закрыть',
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
