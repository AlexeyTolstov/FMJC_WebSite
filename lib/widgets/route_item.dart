import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// `RouteItemWidget` - элемент построения маршрута
class RouteItemWidget extends StatelessWidget {
  final int index;
  final String text;
  final LatLng latLng;
  final VoidCallback onTapDelete;

  const RouteItemWidget({
    super.key,
    required this.index,
    required this.onTapDelete,
    required this.text,
    required this.latLng,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 450,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text((index + 1).toString()),
          SizedBox(width: 10),
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                    '${latLng.latitude.toStringAsFixed(3)} / ${latLng.longitude.toStringAsFixed(3)}'),
              ],
            ),
          ),
          SizedBox(width: 10),
          ReorderableDragStartListener(
            child: Icon(Icons.menu),
            index: index,
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: onTapDelete,
            icon: Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
