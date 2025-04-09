import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maps_application/user_service.dart';

Future<void> set_estimation({
  required int id,
  required int estimation,
}) async {
  int c_est = await get_user_estimation(id);

  if (estimation == 0) {
    await http.post(
      Uri.parse(
          'https://j-cupfirst-sleep.amvera.io/estimations/del_estimation/'),
      body: jsonEncode({
        "point_id": id,
        "user_token": UserService().userId,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } else {
    if (c_est != 0) {
      await http.post(
        Uri.parse(
            'https://j-cupfirst-sleep.amvera.io/estimations/del_estimation/'),
        body: jsonEncode({
          "point_id": id,
          "user_token": UserService().userId,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
    await http.post(
      Uri.parse(
          'https://j-cupfirst-sleep.amvera.io/estimations/add_estimation/'),
      body: jsonEncode({
        "estimation": estimation,
        "point_id": id,
        "user_token": UserService().userId,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<int> get_user_estimation(int id) async {
  final response = await http.post(
    Uri.parse(
        'https://j-cupfirst-sleep.amvera.io/estimations/get_user_estimation/'),
    body: jsonEncode({
      "point_id": id,
      "user_token": UserService().userId,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  final body = jsonDecode(utf8.decode(response.bodyBytes));
  return body['message'];
}
