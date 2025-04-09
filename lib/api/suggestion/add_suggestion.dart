import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:maps_application/exceptions/create_exceptions.dart';
import 'package:maps_application/user_service.dart';

Future<void> add_proposal({
  required String name,
  required String description,
  required String category,
}) async {
  final response = await http.post(
    Uri.parse('https://j-cupfirst-sleep.amvera.io/proposal/add_proposal/'),
    body: jsonEncode({
      "name": name,
      "description": description,
      "sphere": category,
      "user_token": UserService().userId,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode != 200) throw AddSuggestionException();
}

Future<void> add_point({
  required String name,
  required String description,
  required LatLng coord,
}) async {
  print('add point');
  final response = await http.post(
    Uri.parse('https://j-cupfirst-sleep.amvera.io/point/add_point/'),
    body: jsonEncode({
      "name": name,
      "description": description,
      "coordinates": [coord.latitude, coord.longitude],
      "user_token": UserService().userId,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  print(response.body);
  print(response.statusCode);

  if (response.statusCode != 200) throw AddSuggestionException();
}

Future<void> add_route({
  required String name,
  required String description,
  required List<LatLng> route,
}) async {
  print(
      route.map((LatLng coord) => [coord.latitude, coord.longitude]).toList());
  final response = await http.post(
    Uri.parse('https://j-cupfirst-sleep.amvera.io/route/add_route/'),
    body: jsonEncode({
      "name": name,
      "description": description,
      "coordinates": route
          .map((LatLng coord) => [coord.latitude, coord.longitude])
          .toList(),
      "user_token": UserService().userId,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode != 200) throw AddSuggestionException();
}
