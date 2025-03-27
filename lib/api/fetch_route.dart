import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<LatLng>> fetchRoute(List<LatLng> listCoords) async {
  if (listCoords.length < 2) {
    return [];
  }

  final pointsString =
      listCoords.map((p) => '${p.longitude},${p.latitude}').join(';');

  final url = Uri.parse(
      'http://router.project-osrm.org/route/v1/driving/$pointsString?overview=full&geometries=polyline');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['routes'].isNotEmpty) {
      final route = data['routes'][0]['geometry'];
    }
  }

  return [];
}
