import 'package:flutter/material.dart';
import 'package:maps_application/styles/images.dart';

class OKButton extends StatelessWidget {
  const OKButton({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Image(
        width: 50,
        image: ApplicationImages.OKImage,
      ),
    );
  }
}
