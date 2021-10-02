import 'package:acumenmobile/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App theme will be customized from here .. to update UI easily later..
final appTheme = ThemeData(
  primarySwatch: MaterialColor(primaryColorAndPrimaryButtonColor.value, {
    50: primaryColorAndPrimaryButtonColor,
    100: primaryColorAndPrimaryButtonColor,
    200: primaryColorAndPrimaryButtonColor,
    300: primaryColorAndPrimaryButtonColor,
    400: primaryColorAndPrimaryButtonColor,
    500: primaryColorAndPrimaryButtonColor,
    600: primaryColorAndPrimaryButtonColor,
    700: primaryColorAndPrimaryButtonColor,
    800: primaryColorAndPrimaryButtonColor,
    900: primaryColorAndPrimaryButtonColor,
  }),
  fontFamily: GoogleFonts.notoSans().fontFamily,
);
