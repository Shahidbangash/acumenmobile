// this file will deal with Login Singn up and get Current User

import 'package:acumenmobile/Routes/goToRoutes.dart';
import 'package:acumenmobile/Routes/routesConstants.dart';
import 'package:acumenmobile/reusableFunction/showCustomSnackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

void goToLoginScreen() {
  Navigator.of(navigatorKey!.currentState!.context)
      .pushNamedAndRemoveUntil(loginPageRoute, (route) => false);
}

Future<String> signup({
  required String email,
  required String password,
  required String name,
}) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    FirebaseAuth.instance.currentUser!
        .updateDisplayName(name)
        .then((value) async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(getCurrentUser()!.uid)
          .set({
        "email": email,
        "uid": getCurrentUser()!.uid,
        "displayName": getCurrentUser()!.displayName,
      });

      return "success";
    });
    return "success";
  } on FirebaseAuthException catch (authException) {
    showCustomSnackbar(
      message: authException.message.toString(),
    );
    return "error";
  }
}

Future<String> login({
  required String email,
  required String password,
}) async {
  String message = "";
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    // if (userCredential) {
    goToMainScreen();
    message = "success";
    return message;
    // }
  } on FirebaseAuthException catch (firebaseAuthException) {
    print(firebaseAuthException.code);
    print(firebaseAuthException.message);
    showCustomSnackbar(
      message: firebaseAuthException.message.toString(),
    );
    message = "error";
    return message;
  }
  return message;
}
