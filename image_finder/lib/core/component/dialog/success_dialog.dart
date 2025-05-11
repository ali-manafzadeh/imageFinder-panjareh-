import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

void showSuccessDialog(
  BuildContext context, [
  String? message,
]) {
  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Icon(
                CupertinoIcons.check_mark_circled,
                color: Colors.green,
                size: 86,
              ),
            ),
            if (message != null) ...[
              Text(message,
                  style: TextStyle(
                      fontFamily: "vazir", fontWeight: FontWeight.w600)
                  // Theme.of(context).textTheme.titleMedium,
                  ),
              const SizedBox(height: 32),
            ]
          ],
        ),
      );
    },
  );
}
