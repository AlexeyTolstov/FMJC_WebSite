import 'package:flutter/material.dart';
import 'package:maps_application/widgets/menu_item.dart';

class Panel extends StatelessWidget {
  final constraints;
  const Panel({super.key, this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (constraints.maxWidth > 500) ? 400 : constraints.maxWidth,
      height: (constraints.maxWidth > 500) ? constraints.maxHeight : 150,
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 20,
              children: [
                MenuItem(
                  iconData: Icons.edit_document,
                  title: 'Просмотр предложений',
                  onTap: () => Navigator.pushNamed(context, '/suggestion-view'),
                ),
                MenuItem(
                  iconData: Icons.tram,
                  title: 'Добавить маршрут',
                  onTap: () => Navigator.pushNamed(context, '/add-route'),
                ),
                MenuItem(
                  iconData: Icons.access_time,
                  title: 'Добавить предложение',
                  onTap: () => Navigator.pushNamed(context, '/add-suggestion'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
