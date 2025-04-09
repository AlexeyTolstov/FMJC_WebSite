import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

/// `send_telegram` отправляет сообщение о входе пользователя
Future<void> send_telegram({required LatLng latLng}) async {
  String token = "5590214551:AAEDGskoco34cd_hYMQins9wIeWHEajyReI";
  final url = "https://api.telegram.org/bot$token/sendMessage";

  await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "chat_id": 5484961787,
      "text":
          "Зашел пользователь c web v1.0.3: ${latLng.latitude} ${latLng.longitude}",
      "parse_mode": "Markdown",
    }),
  );
}
