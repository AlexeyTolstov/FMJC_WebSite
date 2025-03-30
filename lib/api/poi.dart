import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// POI (point of interest) - достопримечательность или другой объект, отмеченный точкой на карте.

class POIData {
  final int id;
  // final String name;
  final LatLng latLng;
  final String amenity;

  final Map<String, dynamic> tags;

  POIData({
    required this.id,
    // required this.name,
    required this.latLng,
    required this.amenity,
    required this.tags,
  });

  factory POIData.fromJson(Map<String, dynamic> json) {
    return POIData(
      id: json['id'],
      // name: json['tags']['name'],
      latLng: LatLng(json['lat'], json['lon']),
      amenity: json['tags']['amenity'],
      tags: json['tags'],
    );
  }

  @override
  String toString() {
    return 'POI Data: $latLng';
  }
}

Future<List<POIData>> fetchPoi(LatLng latLng, int radius) async {
  final url = Uri.parse('https://overpass-api.de/api/interpreter');
  final query = '''
  [out:json];
  (
    node["amenity"](around:$radius, ${latLng.latitude}, ${latLng.longitude});
  );
  out;
  ''';

  final response = await http.post(
    url,
    body: {'data': query},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final elements = data['elements'];

    List<POIData> result = [];
    for (final e in elements) {
      result.add(POIData.fromJson(e));
    }
    return result;
  } else {
    throw Exception('Ошибка запроса: ${response.statusCode}');
  }
}
