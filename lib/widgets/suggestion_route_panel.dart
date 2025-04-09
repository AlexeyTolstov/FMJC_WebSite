import 'package:flutter/material.dart';
import 'package:maps_application/styles/button_styles.dart';

class SuggestionRoutePanel extends StatefulWidget {
  final VoidCallback onClose;
  final void Function(String, String) onSend;

  SuggestionRoutePanel(
      {super.key, required this.onClose, required this.onSend});

  @override
  State<SuggestionRoutePanel> createState() => _SuggestionRoutePanelState();
}

class _SuggestionRoutePanelState extends State<SuggestionRoutePanel> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? errorTextName;
  String? errorTextDesc;

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
              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorText: errorTextName,
                        labelText: "Название идеи",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorText: errorTextDesc,
                        labelText: "Описание идеи",
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
                                  if (nameController.text.length == 0)
                                    errorTextName =
                                        'Поле не должно быть пустым';

                                  if (descriptionController.text.length == 0)
                                    errorTextDesc =
                                        'Поле не должно быть пустым';

                                  setState(() {});

                                  return;
                                }
                                widget.onSend(
                                  nameController.text,
                                  descriptionController.text,
                                );
                              },
                              child: Text('Сохранить'),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onClose();
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
