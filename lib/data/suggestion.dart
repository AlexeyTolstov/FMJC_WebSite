import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:latlong2/latlong.dart';

List<String> suggestionCategories = [
  '---Не указана---',
  'Экология',
  'Культура',
  'Благоустройство',
  'Транспорт',
  'Парки',
  'Передвижение по городу',
  'Велосипеды и самокаты',
  'Ж/Д инфраструктура',
  'Соц. сфера'
];

int suggestionId = 0;

class Suggestion {
  late int id;
  int author_id;
  String name;
  String description;

  LatLng? coords;
  String? category;
  List<LatLng>? route;

  Suggestion({
    required this.name,
    required this.description,
    required this.author_id,
    this.coords,
    this.category,
    this.route,
  }) {
    id = suggestionId++;
  }

  @override
  String toString() {
    return '$name: \n$description\n';
  }
}
