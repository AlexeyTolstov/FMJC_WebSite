import 'package:flutter/material.dart';
import 'package:maps_application/styles/app_colors.dart';

abstract class AuthButtonsStyles {
  static final ButtonStyle mainButton = ButtonStyle(
    foregroundColor:
        WidgetStateProperty.all(AuthColors.mainButtonForegroundColor),
    backgroundColor:
        WidgetStateProperty.all(AuthColors.mainButtonBackgroundColor),
    shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  );

  static final ButtonStyle secondaryButton = ButtonStyle(
    foregroundColor:
        WidgetStateProperty.all(AuthColors.secondaryButtonForegroundColor),
    backgroundColor:
        WidgetStateProperty.all(AuthColors.secondaryButtonBackgroundColor),
    side: WidgetStateProperty.all(
        BorderSide(color: AuthColors.secondaryButtonForegroundColor)),
    shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
  );
}

abstract class AppButtonStyles {
  static final ButtonStyle saveButton = ButtonStyle(
    foregroundColor:
        WidgetStateProperty.all(AppColors.saveButtonColorForeground),
    backgroundColor:
        WidgetStateProperty.all(AppColors.saveButtonColorBackground),
  );

  static final ButtonStyle cancelButton = ButtonStyle(
    foregroundColor:
        WidgetStateProperty.all(AppColors.cancelButtonColorForeground),
    backgroundColor:
        WidgetStateProperty.all(AppColors.cancelButtonColorBackground),
  );
}
