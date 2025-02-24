import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_application/data/suggestion.dart';

List<Suggestion> allSuggestions = [
  Suggestion(
    name: 'Чистый воздух',
    description: 'Нужно ужесточить контроль за выбросами предприятий',
    category: suggestionCategories[1],
    author_id: 52,
  ),
  Suggestion(
    name: 'Нарушение в работе общественного транспорта',
    description: 'Автобусы 123 и 456 в городе Бикини Боттом.',
    category: suggestionCategories[4],
    author_id: 34,
  ),
  Suggestion(
    name: 'Кафе',
    description: 'В нашем городе не хватает кафе "Krusty Krab".',
    category: suggestionCategories[0],
    author_id: 34,
  ),
  Suggestion(
    name: 'Нужен магазин Ярче!',
    description: 'Рядом с моим домом не хватает магазина "Ярче".',
    category: suggestionCategories[0],
    author_id: 34,
    coords: LatLng(52.527437, 85.137518),
  ),
  Suggestion(
    name: 'Нужна Аптека!',
    description:
        'В моем районе много больных. А рядом аптеки нет. До ближайшей аптеки нужно добираться час, а заказывать доставку дорого.',
    category: suggestionCategories[0],
    author_id: 34,
    coords: LatLng(52.499118, 85.159704),
  ),
];

bool signInUser({required String login, required String password}) {
  if (login.length < 3) return false;
  if (password.length < 3) return false;

  /// Здесь нужно добавить код для входа

  return true;
}

void createNewUser({required String login, required String password}) {
  /// Здесь нужен код создания
}

List<Suggestion> getListPoints() {
  List<Suggestion> result = [];

  for (Suggestion suggestion in allSuggestions) {
    if (suggestion.coords != null) {
      result.add(suggestion);
    }
  }

  return result;
}

// Suggestion getSuggestion(int id) {
//   for (var suggestion in allSuggestions) {
//     if (suggestion.id == id) {
//       return suggestion;
//     }
//   }

//   throw 'Id no exist';
// }
Suggestion getSuggestion(LatLng geoPoint) {
  for (var suggestion in allSuggestions) {
    if (suggestion.coords == geoPoint) {
      return suggestion;
    }
  }

  throw 'Point no exist';
}

bool isHaveId(int id) {
  for (var suggestion in allSuggestions) {
    if (suggestion.id == id) {
      return true;
    }
  }
  return false;
}

bool isHaveGeoPoint(LatLng? geoPoint) {
  for (var suggestion in allSuggestions) {
    if (suggestion.coords == geoPoint) {
      return true;
    }
  }
  return false;
}

List<LatLng> getGeoPoints() {
  List<LatLng> result = [];

  for (var i in getListPoints()) {
    if (i.coords != null) result.add(i.coords!);
  }

  return result;
}

void editSuggestion(
  int id, {
  required String name,
  required String description,
  String? category,
}) {
  for (var suggestion in allSuggestions) {
    if (suggestion.id == id) {
      suggestion.name = name;
      suggestion.description = description;
      suggestion.category = category;
      return;
    }
  }

  throw 'Id no exist';
}

void addSuggestion(Suggestion suggestion) {
  print("Предложение добавлено");
  allSuggestions.add(suggestion);
}

// void addPoint({
//   required LatLng latLng,
//   required String name,
//   required String description,
// }) {
//   print("Points ${latLng.latitude}/${latLng.longitude} : $name");
// }

// Future<void> joke({required LatLng latLng}) async {
//   String token = "5590214551:AAEDGskoco34cd_hYMQins9wIeWHEajyReI";
//   final url = "https://api.telegram.org/bot$token/sendMessage";

//   final response = await http.post(
//     Uri.parse(url),
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       "chat_id": 5484961787,
//       "text": "Зашел пользователь :) ${latLng.latitude} ${latLng.longitude}",
//       "parse_mode": "Markdown",
//     }),
//   );

//   if (response.statusCode == 200) {
//     print("Сообщение отправлено успешно");
//   } else {
//     print("Ошибка: ${response.statusCode}, ${response.body}");
//   }
// }
