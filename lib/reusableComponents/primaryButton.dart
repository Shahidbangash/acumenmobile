import 'package:acumenmobile/Theme/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? buttonColor;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadiusGeometry? borderRadius;

  PrimaryButton({
    Key? key,
    this.text,
    this.onTap,
    this.buttonColor,
    this.buttonWidth,
    this.buttonHeight,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.buttonHeight,
      width: this.buttonWidth,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 16,
          ),
          margin: EdgeInsets.only(left: 20, right: 20, top: 28),
          decoration: BoxDecoration(
            color: this.buttonColor ?? primaryColorAndPrimaryButtonColor,
            borderRadius: this.borderRadius ?? BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              this.text ?? "Enter Text",
              style: TextStyle(
                fontSize: this.fontSize ?? 14,
                color: this.textColor ?? whiteColor,
                fontWeight: this.fontWeight ?? FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
