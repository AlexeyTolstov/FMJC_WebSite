import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maps_application/exceptions/auth_exceptions.dart';
import 'package:maps_application/user_service.dart';

Future<void> sign_in({
  required String login,
  required String password,
}) async {
  UserService().userId = '1234';

  /*
  final response = await http.get(
    Uri.parse(
        'https://fmjc-biysk-pc.cloudpub.ru/user/sign-in?login=123456&password=123456'),
    headers: {"Content-Type": "application/json; charset=utf-8"},
  );

  // final response = await http.post(
  //   Uri.parse('https://fmjc-biysk-pc.cloudpub.ru/user/sign-in'),
  //   body: jsonEncode(
  //     {
  //       'login': '123456',
  //       'password': '123456',
  //     },
  //   ),
  //   headers: {"Content-Type": "application/json"},
  // );

  if (response.statusCode == 404) {
    throw UserNotFound();
  }

  final data = jsonDecode(response.body);
  print(data);
  */
}

Future<void> sign_up({
  required String login,
  required String password,
}) async {
  UserService().userId = '1234';
}
