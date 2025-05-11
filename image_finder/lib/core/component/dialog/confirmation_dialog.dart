import 'package:flutter/material.dart';

Future<T?> showConfirmationDialog<T>(
  BuildContext context, {
  required String title,
  String? desc,
  String leftText = "لغو ",
  String rightText = "تایید",
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title,
            style: TextStyle(
                fontFamily: "vazir", fontWeight: FontWeight.w600, fontSize: 14)
            //  Theme.of(context).textTheme.titleLarge,
            ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (desc != null)
              Text(
                desc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(leftText,
                style: TextStyle(
                    fontFamily: "vazir",
                    // fontWeight: FontWeight.w600,
                    color: Colors.white)
                // Theme.of(context).textTheme.bodyMedium,
                ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(rightText,
                style: TextStyle(
                    fontFamily: "vazir",
                    // fontWeight: FontWeight.w600,
                    color: Colors.white)),
          )
        ],
      );
    },
  );
}
