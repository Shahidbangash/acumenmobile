import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadImagetFirebase(String imagePath) async {
  return await FirebaseStorage.instance
      .ref(imagePath)
      .putFile(File(imagePath))
      .then((taskSnapshot) {
    // download url when it is uploaded
    if (taskSnapshot.state == TaskState.success) {
      return FirebaseStorage.instance
          .ref(imagePath)
          .getDownloadURL()
          .then((url) {
        return url;
      }).catchError((onError) {
        print("Got Error $onError");
        return null;
      });
    }
  });
}
