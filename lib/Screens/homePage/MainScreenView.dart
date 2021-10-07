import 'dart:io';

import 'package:acumenmobile/reusableComponents/rectanglePainter.dart';
import 'package:acumenmobile/reusableFunction/calculateSmile.dart';
import 'package:acumenmobile/reusableFunction/createImageStream.dart';
import 'package:acumenmobile/reusableFunction/detectFace.dart';
import 'package:acumenmobile/utils/const.dart';
import 'package:export_video_frame/export_video_frame.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class MainPageScreen extends StatefulWidget {
  MainPageScreen({Key? key}) : super(key: key);

  @override
  _MainPageScreenState createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  // final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
// final digitalInkRecogniser = GoogleMlKit.vision.digitalInkRecogniser();
  final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableTracking: true,
    enableClassification: true,
    enableLandmarks: true,
    mode: FaceDetectorMode.accurate,
  ));
  final imageLabeler = GoogleMlKit.vision.imageLabeler();
  // InputImage? inputImage;
  Stream<File>? imagesStream;
// final poseDetector = GoogleMlKit.vision.poseDetector();
// final textDetector = GoogleMlKit.vision.textDetector();
  int selectedIndex = 0;
  final objectDetector =
      GoogleMlKit.vision.objectDetector(ObjectDetectorOptions(
    classifyObjects: true,
    trackMutipleObjects: true,
  ));
  @override
  void initState() {
    super.initState();
  }

  void pickImage({ImageSource imageSource = ImageSource.gallery}) {
    ImagePicker()
        .pickImage(
      source: imageSource,
    )
        .then(
      (value) async {
        Navigator.of(context).pop();
        setState(() {
          imagesStream = createImageStream(xFile: value);
        });
      },
    );
  }

  void pickVideo(
      {ImageSource imageSource = ImageSource.gallery, Duration? duration}) {
    ImagePicker()
        .pickVideo(
      source: ImageSource.gallery,
      maxDuration: duration ??
          Duration(
            seconds: 600,
          ),
    )
        .then((value) {
      setState(() {
        Navigator.of(context).pop();
        imagesStream = ExportVideoFrame.exportImagesFromFile(
          File(value!.path), const Duration(milliseconds: 500), 0,
          // 3.14 / 2,
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    faceDetector.close();
    imageLabeler.close();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<File>(
            stream: imagesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("Image Data is ${snapshot.data}");
                detectFaces(
                  inputImage: InputImage.fromFilePath(
                    snapshot.data!.path,
                  ),
                );
                return Column(
                  children: [
                    SizedBox(
                      height: height * 0.3,
                      width: width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          fit: BoxFit.cover,
                          image: FileImage(
                            File(
                              snapshot.data!.path,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Result of image will be here

                    StreamBuilder<List<Face>>(
                      stream: detectFaces(
                        inputImage: InputImage.fromFilePath(
                          snapshot.data!.path,
                        ),
                      ).asStream(),
                      builder: (context, faceResult) {
                        if (faceResult.hasData) {
                          if (faceResult.data!.length == 0) {
                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                faceResult.data.toString(),
                              ),
                            );
                          }
                          return Flex(
                            direction: Axis.vertical,
                            children: faceResult.data!.map(
                              (face) {
                                return Container(
                                  child: Card(
                                    child: Flex(
                                      direction: Axis.vertical,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          width: width,
                                          child: Wrap(
                                            children: [
                                              Text(
                                                "Face Bounding Position",
                                              ),
                                              Text(
                                                face.boundingBox.toString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          width: width,
                                          child: Wrap(
                                            children: [
                                              Text("Emotion: "),
                                              Text(
                                                face.smilingProbability != null
                                                    ? calculateSmile(
                                                        smilingProbability: face
                                                            .smilingProbability,
                                                      )
                                                    : "",
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            color: Colors.white,
                                            width: 300,
                                            height: 300,
                                            child: CustomPaint(
                                              painter: RectanglePainter(
                                                rect: face.boundingBox,
                                                color: Colors.black,
                                              ),
                                              child: Text(
                                                "Custom Paint",
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            // Container(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Text(
                            //     faceResult.data.toString(),
                            //   ),
                            // ),
                            // ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),

                    // Result of image ends here
                  ],
                );
              } else {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "No Media Selected Yet",
                        textScaleFactor: 1.4,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
