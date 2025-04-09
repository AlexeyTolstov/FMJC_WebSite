import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_application/api/fetch_route.dart';
import 'package:maps_application/api/suggestion/estimation.dart';
import 'package:maps_application/api/suggestion/get_suggestion_id.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/styles/font_styles.dart';

class SuggestionIdPage extends StatefulWidget {
  final String id;

  SuggestionIdPage({super.key, required this.id});

  @override
  State<SuggestionIdPage> createState() => _SuggestionIdPageState();
}

class _SuggestionIdPageState extends State<SuggestionIdPage> {
  Suggestion? _suggestion;
  final controller = MapController();

  int likes = 0;
  int dislikes = 0;

  int userEstimation = 0;
  bool isReady = false;

  @override
  void initState() {
    get_suggestion_by_id(id: int.tryParse(widget.id)).then((v) {
      setState(() {
        _suggestion = v;
        likes = _suggestion!.likes ?? -1;
        dislikes = _suggestion!.dislikes ?? -1;
        isReady = true;
      });

      get_user_estimation(_suggestion!.id).then((v) {
        setState(() {
          userEstimation = v;
        });
      });
    });

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
          if (isReady && _suggestion == null)
            Text('Упс... Ничего не найдено')
          else if (isReady && _suggestion != null)
            Center(
              child: Column(
                children: [
                  Text(
                    '${_suggestion!.name}      ID: ${_suggestion!.id}',
                    style: SuggestionPageTextStyles.header,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _suggestion!.description,
                    style: SuggestionPageTextStyles.description,
                  ),
                  SizedBox(height: 10),
                  Text('Author ID: ${_suggestion!.author_id}'),
                  SizedBox(height: 10),
                  if (_suggestion!.coords != null)
                    PointMap(suggestion: _suggestion!),
                  if (_suggestion!.route != null)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RouteMap(routePoints: _suggestion!.route!),
                    ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (userEstimation == 1)
                                userEstimation = 0;
                              else
                                userEstimation = 1;
                              set_estimation(
                                id: _suggestion!.id,
                                estimation: userEstimation,
                              ).then((v) {
                                get_suggestion_by_id(id: _suggestion!.id)
                                    .then((v) {
                                  if (_suggestion!.id != -1)
                                    setState(() {
                                      _suggestion = v!;
                                      likes = _suggestion!.likes ?? -1;
                                      dislikes = _suggestion!.dislikes ?? -1;
                                    });
                                });
                              });
                            },
                            icon: (userEstimation != 1)
                                ? Icon(Icons.thumb_up_outlined)
                                : Icon(Icons.thumb_up_alt),
                          ),
                          Text(likes.toString()),
                        ],
                      ),
                      SizedBox(width: 30),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (userEstimation == -1)
                                  userEstimation = 0;
                                else
                                  userEstimation = -1;

                                set_estimation(
                                  id: _suggestion!.id,
                                  estimation: userEstimation,
                                ).then((v) {
                                  get_suggestion_by_id(id: _suggestion!.id)
                                      .then((v) {
                                    if (_suggestion!.id != -1)
                                      setState(() {
                                        _suggestion = v!;
                                        likes = _suggestion!.likes ?? -1;
                                        dislikes = _suggestion!.dislikes ?? -1;
                                      });
                                  });
                                });
                              });
                            },
                            icon: (userEstimation != -1)
                                ? Icon(Icons.thumb_down_outlined)
                                : Icon(Icons.thumb_down_alt),
                          ),
                          Text(dislikes.toString()),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (!isReady) Text('Ищем предложение')
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
      width: 200,
      height: 200,
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
      width: 200,
      height: 200,
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
