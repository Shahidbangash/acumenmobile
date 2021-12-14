import 'package:tflite/tflite.dart';

loadModel() async {
  await Tflite.loadModel(
    model: "assets/model_unquant.tflite",
    labels: "assets/labels.txt",
  );
}
