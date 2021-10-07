import 'package:google_ml_kit/google_ml_kit.dart';

Future<List<Face>> detectFaces({required InputImage inputImage}) async {
  final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableClassification: true,
    enableContours: true,
    enableTracking: true,
    enableLandmarks: true,
  ));
  // faceDetector.options.enableClassification;
  final List<Face> faces = await faceDetector.processImage(inputImage);

  faces.forEach((face) {
    print("Face smilling ${face.smilingProbability}");
    print("Face ${face.trackingId}");
  });
  return faces;
}
