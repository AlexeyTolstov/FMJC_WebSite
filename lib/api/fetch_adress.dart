import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// `fetchAdress` - получение улицы по координатам `LatLng`
Future<String> fetchAdress(LatLng latLng) async {
  final response = await http.get(
    Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&format=jsonv2'),
    headers: {"Content-Type": "application/json"},
  );

  final body = jsonDecode(response.body);
  return body['address']['road'];
}
