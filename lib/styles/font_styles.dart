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

abstract class MainTextStyles {
  static const TextStyle header = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontSize: 20,
  );

  static const TextStyle title = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontSize: 17,
  );
}

abstract class FileUploadTextStyles {
  static const TextStyle name = TextStyle(
    color: Colors.black,
    fontSize: 17,
  );

  static const TextStyle size = TextStyle(
    color: Colors.black,
    fontSize: 12,
  );
}

abstract class SuggestionItemTextStyles {
  static const TextStyle title = TextStyle(
    color: Colors.black,
    fontSize: 17,
  );

  static const TextStyle description = TextStyle(
    color: Colors.black,
    fontSize: 15,
  );

  static const TextStyle score = TextStyle(
    color: Colors.black,
    fontSize: 13,
  );
}

abstract class SuggestionPageTextStyles {
  static const TextStyle header = TextStyle(
    color: Colors.black,
    fontSize: 20,
  );

  static const TextStyle description = TextStyle(
    color: Colors.black,
    fontSize: 15,
  );
}
