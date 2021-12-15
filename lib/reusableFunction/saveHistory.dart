import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveHistory({required Map<String, dynamic> historyData}) async {
  if (FirebaseAuth.instance.currentUser != null) {
    User? user = FirebaseAuth.instance.currentUser;
    historyData["userId"] = user!.uid;
    await FirebaseFirestore.instance
        .collection("history")
        .doc()
        .set(historyData)
        .then((value) {
      return null;
    });
  }
}



// https://teachablemachine.withgoogle.com/models/8vriu9_F3/  