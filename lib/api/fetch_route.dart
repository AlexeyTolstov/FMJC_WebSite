import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// `fetchRoute` - функция для поиска маршрутов между 2+ точками
Future<List<LatLng>> fetchRoute(List<LatLng> points) async {
  if (points.length < 2) {
    return [];
  }

  final pointsString =
      points.map((p) => '${p.longitude},${p.latitude}').join(';');

  final url = Uri.parse(
      'http://router.project-osrm.org/route/v1/driving/$pointsString?overview=full&geometries=polyline');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));

    if (data['routes'].isNotEmpty) {
      final polylinePoints = PolylinePoints();
      final decodedPoints =
          polylinePoints.decodePolyline(data['routes'][0]['geometry']);

      return decodedPoints.map((p) => LatLng(p.latitude, p.longitude)).toList();
    }
  }

  return [];
}
