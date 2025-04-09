import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:maps_application/data/suggestion.dart';

Future<List<Suggestion>> get_list_point() async {
  final response = await http.get(
    Uri.parse('http://j-cupfirst-sleep.amvera.io/point/point_list'),
    headers: {'Content-Type': 'application/json'},
  );
  final body = jsonDecode(utf8.decode(response.bodyBytes));

  return (body as List)
      .map((v) => Suggestion(
          id: v['id'],
          name: v['name'],
          description: v['description'],
          author_id: v['user_token'],
          coords: LatLng(
            v['coordinates'][0],
            v['coordinates'][1],
          )))
      .toList();
}

Future<List<Suggestion>> get_all_suggestion({
  int? id = null,
  bool isPoint = false,
  bool isRoute = false,
  bool isProposal = false,
}) async {
  final queryParams = <String, dynamic>{};

  if (id != null) {
    queryParams['user_token'] = id.toString();
  }

  final types = <String>[];
  if (isPoint) types.add('point');
  if (isRoute) types.add('route');
  if (isProposal) types.add('proposal');

  final uri = Uri.parse('http://j-cupfirst-sleep.amvera.io/all_types/get_all/')
      .replace(queryParameters: queryParams);

  final typesParams = types.map((t) => 'types=$t').join('&');
  final fullUri = uri.toString() +
      (types.isNotEmpty ? (uri.hasQuery ? '&' : '?') + typesParams : '');

  final response = await http.get(
    Uri.parse(fullUri),
    headers: {'Content-Type': 'application/json'},
  );

  final body = jsonDecode(utf8.decode(response.bodyBytes));
  return (body as List)
      .map(
        (v) => Suggestion(
          id: v['id'],
          name: v['name'],
          description: v['description'],
          author_id: v['user_token'],
          coords: (v['type'] == 'point')
              ? LatLng(
                  v['coordinates'][0],
                  v['coordinates'][1],
                )
              : null,
          route: (v['type'] == 'route')
              ? (v['coordinates'] as List)
                  .map((e) => LatLng(e[0], e[1]))
                  .toList()
              : null,
          likes: v['like'],
          dislikes: v['dislike'],
        ),
      )
      .toList();
}
