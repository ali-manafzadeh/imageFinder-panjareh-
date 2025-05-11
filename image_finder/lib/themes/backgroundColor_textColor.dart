import 'dart:ui';

import 'package:flutter/material.dart';

class ColorUtils {
  static Color getTextColor(Color backgroundColor) {
    Brightness brightness =
        ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.light ? Colors.black : Colors.white;
  }
}
