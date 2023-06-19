import 'package:flutter/material.dart';

SnackBar mySnackBar(BuildContext context, String message) {
  return SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    width: 150,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    duration: const Duration(seconds: 1, milliseconds: 500),
  );
}
