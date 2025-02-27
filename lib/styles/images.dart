import 'package:flutter/material.dart';

abstract class ApplicationImages {
  static const gosuslugiImage = AssetImage("assets/images/gosuslugi.png");
  static const VKImage = AssetImage("assets/images/vk.png");
  static const OKImage = AssetImage("assets/images/ok.png");
  static const BackgroundImage = AssetImage("assets/images/background1.jpg");
}

abstract class TutorialImages {
  static const userLocationMarkerImage =
      AssetImage("assets/images/tutorial/1/loc_marker.png");
  static const targetImage = AssetImage('assets/images/tutorial/1/target.png');

  static const suggestionMarkerImage =
      AssetImage("assets/images/tutorial/2/marker.png");
  static const suggestionPanelImage =
      AssetImage('assets/images/tutorial/2/suggestion_on_marker.png');

  static const addSuggestionImage =
      AssetImage('assets/images/tutorial/3/Add_suggestion_panel.png');
}
