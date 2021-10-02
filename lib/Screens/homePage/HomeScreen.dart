// import 'dart:html';
import 'dart:io';

import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/reusableComponents/confirmationDialog.dart';
import 'package:acumenmobile/reusableComponents/drawer.dart';
import 'package:acumenmobile/reusableFunction/createImageStream.dart';
import 'package:acumenmobile/reusableFunction/detectFace.dart';
import 'package:acumenmobile/utils/const.dart';
import 'package:export_video_frame/export_video_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

//  This is the Home Screen

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
// final digitalInkRecogniser = GoogleMlKit.vision.digitalInkRecogniser();
  final faceDetector = GoogleMlKit.vision.faceDetector();
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

  List<Widget> widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      // style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      // style: optionStyle,
    ),
    Text(
      'Index 2: Schools',
      // style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      // style: optionStyle,
    ),
  ];

  @override
  void dispose() {
    super.dispose();
    faceDetector.close();
    imageLabeler.close();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: primaryColorAndPrimaryButtonColor,
              ),
              drawer: CustomDrawer(),
              body: SingleChildScrollView(
                child: Column(
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

                                FutureBuilder(
                                  future: detectFaces(
                                    inputImage: InputImage.fromFilePath(
                                      snapshot.data!.path,
                                    ),
                                  ),
                                  builder: (context, faceResult) {
                                    if (faceResult.hasData) {
                                      return Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          faceResult.data.toString(),
                                        ),
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
                              child: Text("No video Selected Yet"),
                            );
                          }
                        },
                      ),
                    )
                  ],
                  // children: [widgetOptions.elementAt(selectedIndex)],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showCustomDialog(
                    context: context,
                    buttonList: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                pickImage(imageSource: ImageSource.gallery);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Pick Image from Gallery"),
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () {
                                pickImage(imageSource: ImageSource.camera);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Pick Image From Camera"),
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () {
                                pickVideo();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Pick Video From Gallery"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
                backgroundColor: white,
                child: Icon(
                  CupertinoIcons.add,
                  color: black,
                  size: 33,
                ), //icon inside button
                elevation: 33,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                enableFeedback: true,
                backgroundColor: primaryColorAndPrimaryButtonColor,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withOpacity(.60),
                selectedFontSize: 14,
                unselectedFontSize: 14,
                currentIndex: selectedIndex,
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                  // Respond to item press.
                },
                items: [
                  BottomNavigationBarItem(
                    label: "Home",
                    icon: Icon(CupertinoIcons.home),
                  ),
                  BottomNavigationBarItem(
                    label: 'History',
                    icon: Icon(CupertinoIcons.hand_draw),
                  ),
                  BottomNavigationBarItem(
                    label: 'Notification',
                    icon: Icon(CupertinoIcons.bell),
                  ),
                  BottomNavigationBarItem(
                    label: 'Profile',
                    icon: Icon(CupertinoIcons.settings),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
