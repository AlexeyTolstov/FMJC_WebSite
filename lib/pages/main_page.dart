import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_application/api/poi.dart';
import 'package:maps_application/api/search_places.dart';
import 'package:maps_application/api/suggestion/get_suggestion_id.dart';
import 'package:maps_application/api/suggestion/get_suggestion_list.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_application/user_service.dart';
import 'package:maps_application/widgets/panel.dart';
import 'package:maps_application/widgets/search_bar.dart';
import 'package:maps_application/widgets/suggestion_point_panel.dart';
import 'package:maps_application/widgets/tutorial.dart';

import 'dart:math';

double distanceBetweenPoints(LatLng latLng1, LatLng latLng2) {
  const double earthRadiusM = 1113200;

  double avgLat = (latLng1.latitude + latLng2.latitude) / 2;
  double dx = (latLng2.longitude - latLng1.longitude) *
      earthRadiusM *
      cos(avgLat * pi / 180);
  double dy = (latLng2.latitude - latLng1.latitude) * earthRadiusM;

  return sqrt(dx * dx + dy * dy);
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  List<Suggestion> _pointList = [];

  late final Tutorial _tutorial;

  LatLng? tempGeoPoint;
  Suggestion? openedSuggestion;

  bool isReady = false;

  bool isOpened = false;
  Suggestion? tempSuggestion;

  LatLng? lastCenter;
  LatLng? searchPoint;

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
        accuracy: LocationAccuracy.best,
      ),
    );

    _currentLocation = LatLng(position.latitude, position.longitude);
    UserService().userLatLng = _currentLocation;
    _userCurrentLocation();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPosition().whenComplete(() {
      // joke(latLng: _currentLocation ?? LatLng(0, 0));
    });
    get_list_point().then((List<Suggestion> suggestionList) {
      setState(() {
        _pointList = suggestionList;
      });
    });
    // _tutorial = Tutorial(context);
    // Future.delayed(Duration.zero, () => _tutorial.startDialog());
  }

  void onSearchItemTap(Place place) {
    _mapController.move(place.latLng, 15);
    setState(() {
      searchPoint = place.latLng;
    });
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    if (isReady && _mapController.camera.zoom >= 10) {
      isOpened = true;
      tempSuggestion = Suggestion(
        id: -1,
        name: '',
        description: '',
        author_id: UserService().userId!,
        coords: latLng,
      );

      setState(() {});
    }
  }

  void onMapReady() {
    setState(() {
      isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (constraints.maxWidth > 500)
                    Panel(constraints: constraints),
                  Expanded(
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            onTap: _onMapTap,
                            onMapEvent: (MapEvent mapEvent) {
                              if (mapEvent.source ==
                                  MapEventSource.scrollWheel) {
                                setState(() {});
                              }
                            },
                            onMapReady: onMapReady,
                            initialCenter: _currentLocation ?? LatLng(0, 0),
                            initialZoom: 2,
                            minZoom: 0,
                            maxZoom: 100,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                            if (isReady)
                              MarkerLayer(
                                markers: [
                                  if (_mapController.camera.zoom >= 10)
                                    ..._pointList.map((s) => Marker(
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
                                              get_point_by_id(id: s.id)
                                                  .then((v) {
                                                setState(() {
                                                  isOpened = true;
                                                  tempSuggestion = v;
                                                });
                                              });
                                            },
                                          ),
                                        )),
                                  if (searchPoint != null)
                                    Marker(
                                      point: searchPoint!,
                                      child: GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 5,
                                              color: Colors.white,
                                            ),
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          width: 30,
                                          height: 30,
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                        if (!isOpened && _currentLocation != null)
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: FloatingActionButton(
                              onPressed: _userCurrentLocation,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.my_location,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        if (isOpened && tempSuggestion != null)
                          SuggestionPointPanel(
                            isEnable: tempSuggestion!.id == -1,
                            suggestion: tempSuggestion!,
                            onClose: () {
                              setState(
                                () {
                                  isOpened = false;
                                  tempSuggestion = null;

                                  get_list_point().then((v) {
                                    setState(() {
                                      _pointList = v;
                                    });
                                  });
                                },
                              );
                            },
                          ),
                        if (!isOpened)
                          Positioned.fill(
                            left: 50,
                            right: 50,
                            top: 10,
                            child: MySearchBar(
                              onSearchItemTap: onSearchItemTap,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (constraints.maxWidth <= 500 && !isOpened)
              Panel(constraints: constraints),
          ],
        );
      }),
    );
  }
}
