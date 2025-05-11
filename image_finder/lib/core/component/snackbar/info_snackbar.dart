// import 'package:editor_image/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:image_finder/core/theme/app_color.dart';
// import 'package:photo_editor/core/theme/app_color.dart';

void showInfoSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColor.black.withOpacity(0.8),
      content: Text(text),
    ),
  );
}
