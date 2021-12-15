import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deleteHistoryFirebase({required String id}) async {
  return await FirebaseFirestore.instance
      .collection("history")
      .doc(id)
      .delete();
}
