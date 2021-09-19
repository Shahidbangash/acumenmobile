// this file will deal with Login Singn up and get Current User

import 'package:acumenmobile/Routes/routesConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User? getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}

void logOut() {
  FirebaseAuth.instance.signOut().then((value) {
    Navigator.of(navigatorKey!.currentState!.context)
        .pushNamedAndRemoveUntil(homePageRoute, (route) => false);
  });
}

void login() {
  Navigator.of(navigatorKey!.currentState!.context)
      .pushNamedAndRemoveUntil(loginPageRoute, (route) => false);
}
