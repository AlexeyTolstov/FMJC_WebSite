import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_application/api/fetch_address.dart';
import 'package:maps_application/api/fetch_route.dart';
import 'package:maps_application/api/search_places.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/user_service.dart';
import 'package:maps_application/widgets/route_item.dart';
import 'package:maps_application/widgets/search_bar.dart';
import 'package:maps_application/widgets/suggestion_route_panel.dart';

class Point {
  final LatLng latLng;
  String address = 'Улица';

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
  bool isOpened = false;

  @override
  void initState() {
    super.initState();
  }

  void save() {
    setState(() {
      isOpened = true;
    });
  }

  void add_point(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      listPoint.add(Point(latLng: latLng));
    });
    fetchRouteUpdate();
  }

  void fetchRouteUpdate() {
    fetchRoute(listPoint.map((e) => e.latLng).toList()).then((readyRoute) {
      setState(() {
        route = readyRoute;
      });
    });
  }

  void onSearchItemTap(Place place) {
    setState(() {
      listPoint.add(Point(latLng: place.latLng));
    });
    fetchRouteUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (constraints.maxWidth > 500)
                        PanelPoints(
                          listPoint: listPoint,
                          fetchRouteUpdate: fetchRouteUpdate,
                          onSave: save,
                          constraints: constraints,
                        ),
                      Expanded(
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                onTap: add_point,
                                initialCenter: UserService().userLatLng ??
                                    LatLng(52.5008896, 85.147648),
                                initialZoom: 15,
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
                            if (UserService().userLatLng != null)
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    _mapController.move(
                                        UserService().userLatLng!, 15);
                                  },
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.my_location,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            if (isOpened)
                              SuggestionRoutePanel(onClose: () {
                                setState(() {
                                  isOpened = false;
                                });
                              }),
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
              ],
            ),
            if (constraints.maxWidth <= 500)
              PanelPointsBottom(
                listPoint: listPoint,
                fetchRouteUpdate: fetchRouteUpdate,
                onSave: save,
                constraints: constraints,
              ),
          ],
        );
      }),
    );
  }
}

class PanelPoints extends StatefulWidget {
  final BoxConstraints constraints;
  final List<Point> listPoint;
  final VoidCallback onSave;
  final VoidCallback fetchRouteUpdate;

  const PanelPoints({
    super.key,
    required this.listPoint,
    required this.fetchRouteUpdate,
    required this.onSave,
    required this.constraints,
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
      if (point.address == 'Улица')
        fetchAddress(point.latLng).then((String address) {
          setState(() {
            point.address = address;
          });
        });
    }

    return Container(
      color: Colors.white,
      width: 500,
      height: double.infinity,
      child: Column(
        children: [
          Text(
            'Добавить маршрут',
            style: MainTextStyles.header,
          ),
          Text(
            'Точки для маршрута',
            style: MainTextStyles.title,
          ),
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: widget.listPoint.length,
              itemBuilder: (context, index) => ListTile(
                key: ValueKey(index),
                title: RouteItemWidget(
                  index: index,
                  latLng: widget.listPoint[index].latLng,
                  text: widget.listPoint[index].address,
                  onTapDelete: () {
                    onTapDelete(index);
                    widget.fetchRouteUpdate();
                  },
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
          ),
          Text('Вы завершили построение маршрута?'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: widget.onSave,
                  child: Text('Завершить'),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Отмена'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PanelPointsBottom extends StatefulWidget {
  final BoxConstraints constraints;
  final List<Point> listPoint;
  final VoidCallback onSave;
  final VoidCallback fetchRouteUpdate;

  const PanelPointsBottom({
    super.key,
    required this.listPoint,
    required this.fetchRouteUpdate,
    required this.onSave,
    required this.constraints,
  });

  @override
  State<PanelPointsBottom> createState() => _PanelPointsBottomState();
}

class _PanelPointsBottomState extends State<PanelPointsBottom> {
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
      if (point.address == 'Улица')
        fetchAddress(point.latLng).then((String address) {
          setState(() {
            point.address = address;
          });
        });
    }

    return DraggableScrollableSheet(
      initialChildSize: .3,
      minChildSize: .3,
      maxChildSize: .9,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  'Добавить маршрут',
                  style: MainTextStyles.header,
                ),
                Text(
                  'Точки для маршрута',
                  style: MainTextStyles.title,
                ),
                Container(
                  height: 500,
                  child: ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    itemCount: widget.listPoint.length,
                    itemBuilder: (context, index) => ListTile(
                      key: ValueKey(index),
                      title: RouteItemWidget(
                        index: index,
                        latLng: widget.listPoint[index].latLng,
                        text: widget.listPoint[index].address,
                        onTapDelete: () {
                          onTapDelete(index);
                          widget.fetchRouteUpdate();
                        },
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
                ),
                Text('Вы завершили построение маршрута?'),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: widget.onSave,
                        child: Text('Завершить'),
                      ),
                      SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Отмена'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
