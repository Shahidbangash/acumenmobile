import 'package:acumenmobile/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldCustom extends StatelessWidget {
  final TextEditingController? controller;
  final bool? obscureText;
  final int? maxLength;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  TextFormFieldCustom({
    Key? key,
    this.controller,
    this.keyboardType,
    this.validator,
    this.obscureText,
    this.maxLength,
    this.autovalidateMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 6),
      margin: EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        // autovalidateMode: ,
        autovalidateMode: this.autovalidateMode ?? AutovalidateMode.disabled,
        obscureText: this.obscureText ?? false,
        validator: this.validator,
        maxLength: this.maxLength,
        // showCursor: false,
        keyboardType: this.keyboardType ?? TextInputType.emailAddress,
        controller: this.controller,
        decoration: InputDecoration(
            focusColor: black,
            // focusColor: primaryColorAndPrimaryButtonColor,
            border: InputBorder.none,
            counterStyle: TextStyle(
              height: double.minPositive,
            ),
            counterText: ""),
        // inputFormatters: [
        //   LengthLimitingTextInputFormatter(9),
        // ],
      ),
    );
  }
}
