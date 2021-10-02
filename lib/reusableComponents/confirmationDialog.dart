import 'package:acumenmobile/utils/const.dart';
import 'package:flutter/material.dart';

void showCustomDialog({
  required BuildContext context,
  List<Widget>? buttonList,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          elevation: 0.0,
          actions: [
            Container(
              color: Colors.white,
              width: width,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
            )
          ],

          // title: Center(child: Text("Evaluation our APP")),
          content: SizedBox(
            width: width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: buttonList!.map(
                  (e) {
                    return e;
                  },
                ).toList()),
          ));
    },
  );
}
