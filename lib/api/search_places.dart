import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Address {
  final String? houseNumber;
  final String? road;
  final String? city;
  final String? county;
  final String? state;
  final String? region;
  final String? country;
  final String? countryCode;

  Address({
    required this.houseNumber,
    required this.road,
    required this.city,
    required this.county,
    required this.state,
    required this.region,
    required this.country,
    required this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> data) {
    return Address(
      houseNumber: data['house_number'],
      road: data['road'],
      city: data['city'],
      county: data['county'],
      state: data['state'],
      region: data['region'],
      country: data['country'],
      countryCode: data['country_code'],
    );
  }
}

class Place {
  final String displayName;
  final LatLng latLng;
  final Address adress;

  Place({
    required this.displayName,
    required this.adress,
    required this.latLng,
  });

  factory Place.fromJson(Map<String, dynamic> data) {
    return Place(
      displayName: data['properties']['display_name'],
      latLng: LatLng(data['geometry']['coordinates'][1],
          data['geometry']['coordinates'][0]),
      adress: Address.fromJson(
          data['properties']['address'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return '$displayName: $latLng';
  }
}

/// `searchPlaces` - поиск достопримечательностей, улиц и др
Future<List<Place>> searchPlaces(
    {required String query, int limit = 10}) async {
  if (query.length <= 3) {
    return [];
  }

  final response = await http.get(
    Uri.parse(
        'https://nominatim.openstreetmap.org/search.php?q=$query&format=geojson&addressdetails=1&limit=$limit'),
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode != 200) return [];

  final body = json.decode(response.body);

  if (body['features'] is! List) return [];
  return (body['features'] as List)
      .map((data) => Place.fromJson(data as Map<String, dynamic>))
      .toList();
}
