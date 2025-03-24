import 'package:flutter/material.dart';

abstract class AuthTextStyles {
  // Login / SignUn

  static const TextStyle header = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle header_small = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 30,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 20,
  );

  static const TextStyle pharagraph = TextStyle(
    fontSize: 17,
  );
}

abstract class TutorialTextStyles {
  static const TextStyle title = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 30,
  );

  static const TextStyle text = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 17,
  );
}
