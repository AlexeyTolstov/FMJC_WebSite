import 'package:flutter/material.dart';
import 'package:maps_application/styles/app_colors.dart';

abstract class AuthButtonsStyles {
  static final ButtonStyle mainButton = ButtonStyle(
    foregroundColor:
        WidgetStateProperty.all(LoginColors.loginButtonForegroundColor),
    backgroundColor:
        WidgetStateProperty.all(LoginColors.loginButtonBackgroundColor),
    shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  );

  static final ButtonStyle secondaryButton = ButtonStyle(
    foregroundColor:
        WidgetStateProperty.all(LoginColors.signUpButtonForegroundColor),
    backgroundColor:
        WidgetStateProperty.all(LoginColors.signUpButtonBackgroundColor),
    side: WidgetStateProperty.all(
        BorderSide(color: LoginColors.signUpButtonForegroundColor)),
    shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  );
}
