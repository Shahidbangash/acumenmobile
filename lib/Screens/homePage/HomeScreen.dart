// import 'dart:html';
import 'dart:io';

import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/reusableComponents/confirmationDialog.dart';
import 'package:acumenmobile/reusableComponents/drawer.dart';
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
  InputImage? inputImage;
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
          (value) async {},
        );
  }

  void pickVideo(
      {ImageSource imageSource = ImageSource.gallery, Duration? duration}) {
    ImagePicker()
        .pickVideo(
      source: ImageSource.gallery,
      maxDuration: duration ?? Duration(seconds: 60),
    )
        .then((value) {
      return null;
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
  Widget build(BuildContext context) {
    return Container(
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
                  inputImage != null
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: Image(
                            image: FileImage(
                              File(
                                inputImage!.filePath.toString(),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Container(
                          constraints: BoxConstraints(
                            minHeight: height * 0.8,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Click on + button to start session",
                              textScaleFactor: 1.4,
                            ),
                          ),
                        )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<File>(
                      stream: imagesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print("Image Data is ${snapshot.data}");
                          return Image(
                            image: FileImage(
                              File(
                                snapshot.data!.path,
                              ),
                            ),
                          );
                        } else {
                          return Container();
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
    );
  }
}
