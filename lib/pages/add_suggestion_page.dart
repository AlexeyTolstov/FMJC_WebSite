import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maps_application/api/suggestion/add_suggestion.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/styles/button_styles.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/widgets/file_item.dart';

class AddSuggestionPage extends StatefulWidget {
  const AddSuggestionPage({super.key});

  @override
  State<AddSuggestionPage> createState() => _AddSuggestionPageState();
}

class _AddSuggestionPageState extends State<AddSuggestionPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String dropdownvalue = suggestionCategories[0];

  List<FileItem> fileItems = [];

  String? errorTextName, errorTextDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Предложить идею'),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Сферы
                  Text(
                    'Выберите сферу',
                    style: MainTextStyles.title,
                  ),
                  const SizedBox(height: 15),
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

                  /// Название идеи
                  SizedBox(height: 20),
                  Text(
                    'Придумайте название идеи',
                    style: MainTextStyles.title,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Название",
                      border: OutlineInputBorder(),
                      errorText: errorTextName,
                    ),
                    maxLength: 100,
                  ),

                  /// Описание идеи
                  Text(
                    'Опишите идею',
                    style: MainTextStyles.title,
                  ),
                  SizedBox(height: 10),
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

                  /// Прикрепление файлов
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: fileItems,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      style: ButtonStyle(
                          side: WidgetStatePropertyAll(
                        BorderSide(
                          width: 1,
                          color: Colors.blue,
                        ),
                      )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.attach_file),
                          Text('Загрузить файлы'),
                        ],
                      ),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          late final fileItem;
                          fileItem = FileItem(
                            fileName: result.files.last.name,
                            size: result.files.last.size,
                            onCloseTap: () {
                              setState(() {
                                fileItems.remove(fileItem);
                              });
                            },
                          );

                          setState(() {
                            fileItems.add(fileItem);
                          });
                        }
                      },
                    ),
                  ),

                  /// Кнопки
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
                          add_proposal(
                            name: nameController.text,
                            description: descriptionController.text,
                            category: dropdownvalue,
                          );
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
