import 'package:acumenmobile/utils/const.dart';
import 'package:flutter/material.dart';

void showCustomDialog({
  required BuildContext context,
  required Widget title,
  required Widget content,
  List<Widget>? buttonList,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        // backgroundColor: Colors.transparent,
        // contentPadding: EdgeInsets.zero,
        elevation: 0.0,
        actions: buttonList!.map(
          (e) {
            return e;
          },
        ).toList(),
        title: title,
        content: content,
      );
    },
  );
}
