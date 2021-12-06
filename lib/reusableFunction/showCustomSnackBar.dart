import 'package:acumenmobile/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showCustomSnackbar({
  required String message,
  VoidCallback? onTap,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: "Okay",
        onPressed: () {
          onTap!.call();
        },
      ),
    ),
  );
}
