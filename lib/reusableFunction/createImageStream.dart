import 'dart:io';

import 'package:image_picker/image_picker.dart';

Stream<File>? createImageStream({XFile? xFile}) async* {
  yield File(xFile!.path);
}
