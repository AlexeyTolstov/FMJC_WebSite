import 'package:flutter/material.dart';
import 'package:maps_application/styles/images.dart';

class GosuslugiButton extends StatelessWidget {
  const GosuslugiButton({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Image(
        width: 300,
        image: ApplicationImages.gosuslugiImage,
      ),
    );
  }
}
