import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_application/widgets/suggestion_point_panel.dart';

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
    setState(() {});
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
          if (isOpened)
            SuggestionPointPanel(
              suggestion: tempSuggestion!,
              isEnable: tempSuggestion!.author_id == myId,
              onClose: () {
                setState(
                  () {
                    isOpened = false;
                    tempSuggestion = null;
                  },
                );
              },
            ),
        ],
      ),
      floatingActionButton: (!isOpened && _currentLocation != null)
          ? FloatingActionButton(
              onPressed: _userCurrentLocation,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.my_location,
                color: Colors.white,
                size: 32,
              ))
          : null,
    );
  }
}
