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

Route tweenNavigation({required Widget nextScreen}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
