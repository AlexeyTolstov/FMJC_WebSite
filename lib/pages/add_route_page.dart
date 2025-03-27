import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_application/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> searchAdress(LatLng latLng) async {
  final response = await http.get(
    Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&format=jsonv2'),
    headers: {"Content-Type": "application/json"},
  );
  final body = jsonDecode(response.body);
  return body['address']['road'];
}

class Point {
  final LatLng latLng;
  String adress = '';

  Point({required this.latLng});
}

class AddRoutePage extends StatefulWidget {
  const AddRoutePage({super.key});

  @override
  State<AddRoutePage> createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  final _mapController = MapController();
  List<Point> listPoint = [];
  List<LatLng> route = [];

  @override
  void initState() {
    super.initState();
  }

  void add_point(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      listPoint.add(Point(latLng: latLng));
    });
    fetchRouteUpdate();
  }

  void fetchRouteUpdate() {
    fetchRoute().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> fetchRoute() async {
    if (listPoint.length < 2) {
      route = [];
      return;
    }

    final pointsString = listPoint
        .map((p) => '${p.latLng.longitude},${p.latLng.latitude}')
        .join(';');
    final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$pointsString?overview=full&geometries=polyline');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'].isNotEmpty) {
          _decodePolyline(data['routes'][0]['geometry']);
        } else {
          print('Маршрут не найден');
        }
      } else {
        print('Ошибка загрузки маршрута: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка запроса: $e');
    }
  }

  void _decodePolyline(String encodedPolyline) {
    final polylinePoints = PolylinePoints();
    final decodedPoints = polylinePoints.decodePolyline(encodedPolyline);

    setState(() {
      route =
          decodedPoints.map((p) => LatLng(p.latitude, p.longitude)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить маршрут'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onTap: add_point,
              initialCenter: UserService().userLatLng ?? LatLng(0, 0),
              initialZoom: 2,
              minZoom: 0,
              maxZoom: 100,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              CurrentLocationLayer(
                style: LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.white,
                    ),
                  ),
                  markerSize: Size(35, 35),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
              MarkerLayer(
                markers: listPoint
                    .map((Point point) => Marker(
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 50,
                            ),
                            onTap: () {
                              setState(() {});
                            },
                          ),
                          point: point.latLng,
                        ))
                    .toList(),
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
            ],
          ),
          PanelPoints(
            listPoint: listPoint,
            fetchRouteUpdate: fetchRouteUpdate,
          ),
          if (UserService().userLatLng != null)
            Positioned(
              right: 10,
              bottom: 10,
              child: FloatingActionButton(
                onPressed: () {
                  _mapController.move(UserService().userLatLng!, 15);
                },
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PanelPoints extends StatefulWidget {
  final List<Point> listPoint;
  final VoidCallback fetchRouteUpdate;

  const PanelPoints({
    super.key,
    required this.listPoint,
    required this.fetchRouteUpdate,
  });

  @override
  State<PanelPoints> createState() => _PanelPointsState();
}

class _PanelPointsState extends State<PanelPoints> {
  void onTapDelete(int index) {
    setState(() {
      widget.listPoint.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (Point point in widget.listPoint) {
      searchAdress(point.latLng).then((String adress) {
        point.adress = adress;
        print(adress);
      });
    }

    return Container(
      color: Colors.white,
      width: 500,
      height: double.infinity,
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        itemCount: widget.listPoint.length,
        itemBuilder: (context, index) => ListTile(
          key: ValueKey(index),
          title: ReorderableDragStartListener(
            index: index,
            child: PointRouterItem(
              index: index,
              text: widget.listPoint[index].adress,
              onTapDelete: () {
                onTapDelete(index);
                widget.fetchRouteUpdate();
              },
            ),
          ),
        ),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = widget.listPoint.removeAt(oldIndex);
            widget.listPoint.insert(newIndex, item);
            widget.fetchRouteUpdate();
          });
        },
      ),
    );
  }
}

class PointRouterItem extends StatelessWidget {
  final int index;
  final String text;
  final VoidCallback onTapDelete;

  const PointRouterItem({
    super.key,
    required this.index,
    required this.onTapDelete,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text((index + 1).toString()),
          Text(text),
          IconButton(
            onPressed: onTapDelete,
            icon: Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
