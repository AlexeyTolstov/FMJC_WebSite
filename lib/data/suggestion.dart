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
  final int id;
  String author_id;
  String name;
  String description;

  LatLng? coords;
  String? category;
  List<LatLng>? route;

  int? likes;
  int? dislikes;

  Suggestion({
    required this.id,
    required this.name,
    required this.description,
    required this.author_id,
    this.likes,
    this.dislikes,
    this.coords,
    this.category,
    this.route,
  });

  @override
  String toString() {
    return '$name: \n$description\n';
  }
}
