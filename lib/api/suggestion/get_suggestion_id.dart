import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:maps_application/data/suggestion.dart';

Future<Suggestion> get_point_by_id({
  required int id,
}) async {
  final response = await http.get(
    Uri.parse('https://j-cupfirst-sleep.amvera.io/point/$id'),
    headers: {'Content-Type': 'application/json'},
  );
  final body = jsonDecode(utf8.decode(response.bodyBytes));

  return Suggestion(
    id: id,
    name: body['name'],
    description: body['description'],
    author_id: body['user_token'],
    coords: LatLng(body['coordinates'][0], body['coordinates'][1]),
    likes: body['like'],
    dislikes: body['dislike'],
  );
}

Future<Suggestion?> get_suggestion_by_id({
  required int? id,
}) async {
  if (id == null) return null;

  final response = await http.get(
    Uri.parse('https://j-cupfirst-sleep.amvera.io/point/$id'),
    headers: {'Content-Type': 'application/json'},
  );
  final body = jsonDecode(utf8.decode(response.bodyBytes));
  if (response.statusCode != 200) return null;

  return Suggestion(
    id: body['id'],
    name: body['name'],
    description: body['description'],
    author_id: body['user_token'],
    coords: (body['type'] == 'point')
        ? LatLng(
            body['coordinates'][0],
            body['coordinates'][1],
          )
        : null,
    route: (body['type'] == 'route')
        ? (body['coordinates'] as List).map((e) => LatLng(e[0], e[1])).toList()
        : null,
    likes: body['like'],
    dislikes: body['dislike'],
  );
}
