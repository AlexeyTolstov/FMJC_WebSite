import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maps_application/exceptions/auth_exceptions.dart';
import 'package:maps_application/user_service.dart';

Future<void> sign_in({
  required String login,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('https://j-cupfirst-sleep.amvera.io/user/sign-in'),
    body: jsonEncode({
      'login': login,
      'password': password,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 400) {
    throw UserNotFound();
  }

  final data = jsonDecode(utf8.decode(response.bodyBytes));
  UserService().userId = data['token'];
}

Future<void> sign_up({
  required String login,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('https://j-cupfirst-sleep.amvera.io/user/sign-up'),
    body: jsonEncode({
      'login': login,
      'password': password,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 400) {
    throw LoginAlreadyRegistered();
  }

  final data = jsonDecode(utf8.decode(response.bodyBytes));
  UserService().userId = data['token'];
}
