import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:latlong2/latlong.dart';

int myId = 0;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;

  LatLng? tempGeoPoint;
  Suggestion? openedSuggestion;

  List<Suggestion> _listPoints = [];
  List<Marker> _listMarkers = [];

  bool isOpened = false;
  Suggestion? tempSuggestion;

  Future<void> _userCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Current location not available'),
        ),
      );
    }
  }

  Future<void> getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    _currentLocation = LatLng(position.latitude, position.longitude);
    _userCurrentLocation();
  }

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    isOpened = true;
    tempSuggestion = Suggestion(
      name: '',
      description: '',
      author_id: myId,
      coords: latLng,
    );
    setState(() {});
  }

  Widget openPanel(Suggestion suggestion) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    nameController.text = suggestion.name;
    descriptionController.text = suggestion.description;

    return Stack(
      children: [
        GestureDetector(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
          onPanUpdate: (_) {},
          onTap: () {
            setState(() {
              isOpened = false;
              tempSuggestion = null;
            });
          },
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Название",
                        border: OutlineInputBorder(),
                      ),
                      enabled: suggestion.author_id == myId,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Описание",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 10,
                      enabled: suggestion.author_id == myId,
                    ),
                    Row(
                      children: [
                        if (suggestion.author_id == myId)
                          TextButton(
                            onPressed: () {
                              if (isHaveId(suggestion.id)) {
                                editSuggestion(
                                  suggestion.id,
                                  name: nameController.text,
                                  description: descriptionController.text,
                                );
                              } else {
                                addSuggestion(Suggestion(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  author_id: myId,
                                  coords: suggestion.coords,
                                  category: suggestion.category,
                                ));
                              }
                              setState(() {
                                isOpened = false;
                                tempSuggestion = null;
                              });
                            },
                            child: Text('Сохранить'),
                          ),
                        SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isOpened = false;
                              tempSuggestion = null;
                            });
                          },
                          child: Text('Отмема'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _listMarkers = [];
    for (var s in getListPoints()) {
      Marker _marker = Marker(
        width: 50,
        height: 50,
        point: s.coords!,
        child: GestureDetector(
          child: Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 50,
          ),
          onTap: () {
            isOpened = true;
            tempSuggestion = s;
            setState(() {});
          },
        ),
      );
      _listMarkers.add(_marker);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Карта")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onTap: _onMapTap,
              initialCenter: _currentLocation ?? LatLng(0, 0),
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
                markers: _listMarkers,
              ),
            ],
          ),
          if (isOpened) openPanel(tempSuggestion!)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _userCurrentLocation,
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.my_location,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
