import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_application/api/fetch_route.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/styles/font_styles.dart';

Suggestion? getSuggestionById(String id) {
  for (final s in allSuggestions) {
    if (s.id == int.parse(id)) {
      return s;
    }
  }
  return null;
}

class SuggestionIdPage extends StatefulWidget {
  final String id;

  SuggestionIdPage({super.key, required this.id});

  @override
  State<SuggestionIdPage> createState() => _SuggestionIdPageState();
}

class _SuggestionIdPageState extends State<SuggestionIdPage> {
  late final Suggestion? _suggestion;
  final controller = MapController();

  @override
  void initState() {
    _suggestion = getSuggestionById(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_suggestion == null)
      return Scaffold(
        appBar: AppBar(
          title: Text('Ничего не найдено'),
        ),
      );
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            _suggestion.name,
            style: SuggestionPageTextStyles.header,
          ),
          Text(
            _suggestion.description,
            style: SuggestionPageTextStyles.description,
          ),
          Text('Author ID: ${_suggestion.author_id}'),
          if (_suggestion.coords != null) PointMap(suggestion: _suggestion),
          if (_suggestion.route != null)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RouteMap(routePoints: _suggestion.route!),
            ),
        ],
      ),
    );
  }
}

class PointMap extends StatelessWidget {
  final Suggestion suggestion;
  final MapController controller = MapController();
  PointMap({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      child: FlutterMap(
        mapController: controller,
        options: MapOptions(
          initialCenter: suggestion.coords!,
          initialZoom: 15,
          minZoom: 0,
          maxZoom: 100,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: suggestion.coords!,
                child: GestureDetector(
                  child: Icon(
                    Icons.location_pin,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RouteMap extends StatefulWidget {
  final List<LatLng> routePoints;
  const RouteMap({super.key, required this.routePoints});

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  final MapController controller = MapController();
  late final double initialLng;
  late final double initialLat;
  List<LatLng> route = [];

  @override
  void initState() {
    double s_lng = 0;
    double s_lat = 0;

    for (LatLng l in widget.routePoints) {
      s_lng += l.longitude;
      s_lat += l.latitude;
    }

    initialLat = s_lat / widget.routePoints.length;
    initialLng = s_lng / widget.routePoints.length;

    fetchRoute(widget.routePoints).then((v) => setState(() {
          route = v;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: FlutterMap(
        mapController: controller,
        options: MapOptions(
          initialCenter: LatLng(initialLat, initialLng),
          initialZoom: 12,
          minZoom: 0,
          maxZoom: 100,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: route,
                color: Colors.red,
                strokeWidth: 5,
              ),
            ],
          ),
          MarkerLayer(
            markers: widget.routePoints
                .asMap()
                .map(
                  (index, LatLng latLng) => MapEntry(
                    index,
                    Marker(
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        child: Stack(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 50,
                            ),
                            Positioned.fill(
                              top: 5,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          setState(() {});
                        },
                      ),
                      point: latLng,
                    ),
                  ),
                )
                .values
                .toList(),
          ),
        ],
      ),
    );
  }
}
