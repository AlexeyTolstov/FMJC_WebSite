import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_application/api/fetch_address.dart';
import 'package:maps_application/api/fetch_route.dart';
import 'package:maps_application/api/search_places.dart';
import 'package:maps_application/api/suggestion/add_suggestion.dart';
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
                                  markers: listPoint
                                      .asMap()
                                      .map(
                                        (index, Point point) => MapEntry(
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
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Text(
                                                          (index + 1)
                                                              .toString(),
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
                                            point: point.latLng,
                                          ),
                                        ),
                                      )
                                      .values
                                      .toList(),
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
                              SuggestionRoutePanel(
                                onSend: (String name, String description) {
                                  add_route(
                                    name: name,
                                    description: description,
                                    route:
                                        listPoint.map((v) => v.latLng).toList(),
                                  ).then((v) {
                                    Navigator.pop(context);
                                  });
                                },
                                onClose: () {
                                  setState(() {
                                    isOpened = false;
                                  });
                                },
                              )
                            else
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
            if (constraints.maxWidth <= 500 && !isOpened)
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
  String? errorText;

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
          Container(
            width: 400,
            height: 50,
            child: (errorText != null)
                ? Text(
                    errorText!,
                    style: TextStyle(color: Colors.red),
                  )
                : null,
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
                  onPressed: () {
                    if (widget.listPoint.length <= 1) {
                      errorText = 'Для маршрута необходимо больше 2х точек';
                      setState(() {});
                      return;
                    }

                    widget.onSave();
                  },
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
  String? errorText;
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
      initialChildSize: .2,
      minChildSize: .2,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(5),
          child: CustomScrollView(
            controller: scrollController,
            shrinkWrap: true,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: Text('Добавить маршрут',
                              style: MainTextStyles.header)),
                      IconButton(
                        onPressed: () {
                          if (widget.listPoint.length <= 1) {
                            errorText =
                                'Для маршрута необходимо больше 2х точек';
                            setState(() {});
                            return;
                          }
                          widget.onSave();
                        },
                        icon: Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 32,
                          ),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 32,
                          ),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25),
                            // border: Border.all()
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('Точки для маршрута', style: MainTextStyles.title),
                  Container(
                    width: 400,
                    height: 50,
                    child: (errorText != null)
                        ? Text(
                            errorText!,
                            style: TextStyle(color: Colors.red),
                          )
                        : null,
                  ),
                  for (int i = 0; i < widget.listPoint.length; i++)
                    ListTile(
                      key: ValueKey(i),
                      title: RouteItemWidget(
                        index: i,
                        latLng: widget.listPoint[i].latLng,
                        text: widget.listPoint[i].address,
                        onTapDelete: () {
                          onTapDelete(i);
                          widget.fetchRouteUpdate();
                        },
                      ),
                    ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
