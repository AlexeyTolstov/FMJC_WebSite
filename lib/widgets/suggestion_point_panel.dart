import 'package:flutter/material.dart';
import 'package:maps_application/api/suggestion/add_suggestion.dart';
import 'package:maps_application/api/suggestion/estimation.dart';
import 'package:maps_application/api/suggestion/get_suggestion_id.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/styles/button_styles.dart';

class SuggestionPointPanel extends StatefulWidget {
  Suggestion suggestion;
  final VoidCallback onClose;
  final bool isEnable;

  SuggestionPointPanel({
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

  int likes = 0;
  int dislikes = 0;

  int userEstimation = 0;

  String? errorTextName;
  String? errorTextDescription;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.suggestion.name;
    descriptionController.text = widget.suggestion.description;
    likes = widget.suggestion.likes ?? -1;
    dislikes = widget.suggestion.dislikes ?? -1;

    get_user_estimation(widget.suggestion.id).then((v) {
      setState(() {
        userEstimation = v;
        likes = widget.suggestion.likes ?? -1;
        dislikes = widget.suggestion.dislikes ?? -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('$likes $dislikes');
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
                                onPressed: () {
                                  if (userEstimation == 1)
                                    userEstimation = 0;
                                  else
                                    userEstimation = 1;
                                  set_estimation(
                                    id: widget.suggestion.id,
                                    estimation: userEstimation,
                                  ).then((v) {
                                    get_suggestion_by_id(
                                            id: widget.suggestion.id)
                                        .then((v) {
                                      if (widget.suggestion.id != -1)
                                        setState(() {
                                          widget.suggestion = v!;
                                          likes = widget.suggestion.likes ?? -1;
                                          dislikes =
                                              widget.suggestion.dislikes ?? -1;
                                        });
                                    });
                                  });
                                },
                                icon: (userEstimation != 1)
                                    ? Icon(Icons.thumb_up_outlined)
                                    : Icon(Icons.thumb_up_alt),
                              ),
                              Text(likes.toString()),
                            ],
                          ),
                          SizedBox(width: 30),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (userEstimation == -1)
                                      userEstimation = 0;
                                    else
                                      userEstimation = -1;

                                    set_estimation(
                                      id: widget.suggestion.id,
                                      estimation: userEstimation,
                                    ).then((v) {
                                      get_suggestion_by_id(
                                              id: widget.suggestion.id)
                                          .then((v) {
                                        if (widget.suggestion.id != -1)
                                          setState(() {
                                            widget.suggestion = v!;
                                            likes =
                                                widget.suggestion.likes ?? -1;
                                            dislikes =
                                                widget.suggestion.dislikes ??
                                                    -1;
                                          });
                                      });
                                    });
                                  });
                                },
                                icon: (userEstimation != -1)
                                    ? Icon(Icons.thumb_down_outlined)
                                    : Icon(Icons.thumb_down_alt),
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

                                  if (widget.suggestion.id == -1)
                                    add_point(
                                      name: nameController.text,
                                      description: descriptionController.text,
                                      coord: widget.suggestion.coords!,
                                    ).then((v) {});

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
