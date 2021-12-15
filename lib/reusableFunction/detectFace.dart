import 'package:acumenmobile/reusableFunction/saveHistory.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite/tflite.dart';

Future<List<dynamic>?> detectFaces({required InputImage inputImage}) async {
  // final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
  //   enableClassification: true,
  //   enableContours: true,
  //   enableTracking: true,
  //   enableLandmarks: true,
  // ));
  // if (inputImage.filePath != null) {
  // print("Imafe path is ${inputImage.filePath}");
  var prediction =
      await Tflite.runModelOnImage(path: inputImage.filePath.toString());
  prediction!.forEach((element) {
    print("Element is $element");
  });
  print(prediction);
  // }
  // faceDetector.options.enableClassification;
  // final List<Face> faces = await faceDetector.processImage(inputImage);

  // faces.forEach((face) {
  //   print("Face smilling ${face.smilingProbability}");
  //   print("Face ${face.trackingId}");
  // });

  return prediction;
}
