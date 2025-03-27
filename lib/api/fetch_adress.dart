import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// `fetchAdress` - получение улицы по координатам `LatLng`
Future<String> fetchAdress(LatLng latLng) async {
  final response = await http.get(
    Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude.toStringAsFixed(3)}&lon=${latLng.longitude.toStringAsFixed(3)}&format=jsonv2'),
    headers: {"Content-Type": "application/json"},
  );
  print(
      'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude.toStringAsFixed(3)}&lon=${latLng.longitude.toStringAsFixed(3)}&format=jsonv2');

  final body = jsonDecode(response.body);
  return body['address']['road'];
}
