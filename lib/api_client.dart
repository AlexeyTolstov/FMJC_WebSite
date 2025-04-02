import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_application/data/suggestion.dart';

List<Suggestion> allSuggestions = [
  Suggestion(
    name: 'Раздельный сбор отходов',
    description:
        'Необходимо организовать пункты раздельного сбора мусора в каждом районе.',
    category: suggestionCategories[1],
    author_id: 34,
  ),
  Suggestion(
    name: 'Чистый воздух',
    description:
        'Нужно ужесточить контроль за выбросами предприятий в районе АБ',
    category: suggestionCategories[1],
    author_id: 52,
  ),
  Suggestion(
    name: 'Сохранение исторического наследия',
    description:
        'В некоторых районах нужно реставрировать памятники архитектуры и исторические здания.',
    category: suggestionCategories[2],
    author_id: 12,
  ),
  Suggestion(
    name: 'Нарушение в работе общественного транспорта',
    description:
        'Автобусы 123 и 456 в городе Бийск едут не по расписанию. Задержки доходят до 20 минут.',
    category: suggestionCategories[4],
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
    description: 'В моем районе много пожилых людей. Рядом необходима аптека.',
    category: suggestionCategories[0],
    author_id: 34,
    coords: LatLng(52.499118, 85.159704),
  ),
  Suggestion(
    name: 'Навигация и указатели',
    description: 'Установка удобных указателей для ориентирования в городе.',
    category: suggestionCategories[6],
    author_id: 224,
    coords: LatLng(52.501799, 85.144864),
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

// Future<void> getObjects({
//   required LatLng latLng,
//   required int radius,
// }) async {
//   String overpass_url = "https://overpass-api.de/api/interpreter";
//   String query = """
//     [out:json];
//     (
//       node["amenity"](around:${radius}, ${latLng.latitude}, ${latLng.longitude});
//     );
//     out;
//   """;

//   http.get(Uri.dataFromString(content));

//     try:
//         response = requests.get(overpass_url, params={"data": query})
//         response.raise_for_status()  # Вызывает исключение при ошибке HTTP

//         pois = response.json().get("elements", [])
//         if pois:
//             for poi in pois:
//                 print(poi)
//         else:
//             print("POI не найдены в указанном радиусе.")

//     except requests.exceptions.RequestException as e:
//         print(f"Ошибка запроса: {e}")
// }

Future<void> joke({required LatLng latLng}) async {
  String token = "5590214551:AAEDGskoco34cd_hYMQins9wIeWHEajyReI";
  final url = "https://api.telegram.org/bot$token/sendMessage";

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "chat_id": 5484961787,
      "text":
          "Зашел пользователь c web версия v0.2.30: ${latLng.latitude} ${latLng.longitude}",
      "parse_mode": "Markdown",
    }),
  );

  if (response.statusCode == 200) {
    print("Сообщение отправлено успешно");
  } else {
    print("Ошибка: ${response.statusCode}, ${response.body}");
  }
}
