import 'package:acumenmobile/Theme/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;

  PrimaryButton({Key? key, this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12,
        ),
        margin: EdgeInsets.only(left: 20, right: 20, top: 28),
        decoration: BoxDecoration(
          color: primaryColorAndPrimaryButtonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            this.text ?? "Sign up",
            style: TextStyle(
              fontSize: 14,
              color: whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
