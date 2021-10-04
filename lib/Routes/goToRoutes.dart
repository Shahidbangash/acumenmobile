import 'package:acumenmobile/Routes/routesConstants.dart';
import 'package:flutter/material.dart';

void goToLoginScreen() {
  Navigator.of(navigatorKey!.currentState!.context)
      .pushNamedAndRemoveUntil(loginPageRoute, (route) => false);
}

void goToMainScreen() {
  Navigator.of(navigatorKey!.currentState!.context)
      .pushNamedAndRemoveUntil(homePageRoute, (route) => false);
}


// TODO: fix login issue