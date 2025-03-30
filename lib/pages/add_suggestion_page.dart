import 'package:flutter/material.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/styles/button_styles.dart';

class AddSuggestionPage extends StatefulWidget {
  const AddSuggestionPage({super.key});

  @override
  State<AddSuggestionPage> createState() => _AddSuggestionPageState();
}

class _AddSuggestionPageState extends State<AddSuggestionPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String dropdownvalue = suggestionCategories[0];

  String? errorTextName, errorTextDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Предложить идею'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Выберите сферу'),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: dropdownvalue,
                    items: suggestionCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue ?? dropdownvalue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Придумайте название идеи'),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Название",
                  border: OutlineInputBorder(),
                  errorText: errorTextName,
                ),
                maxLength: 100,
              ),
              SizedBox(height: 10),
              Text('Опишите идею'),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Описание",
                  border: OutlineInputBorder(),
                  errorText: errorTextDescription,
                ),
                maxLines: 10,
                maxLength: 500,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                    style: AppButtonStyles.saveButton,
                    onPressed: () {
                      setState(() {
                        if (nameController.text.length == 0) {
                          errorTextName = 'Название не должно быть пустым';
                        } else {
                          errorTextName = null;
                        }
                        if (descriptionController.text.length == 0) {
                          errorTextDescription =
                              'Описание не должно быть пустым';
                        } else {
                          errorTextDescription = null;
                        }
                      });
                      if (nameController.text == '' ||
                          descriptionController.text == '') return;

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
                      'Отмена',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
