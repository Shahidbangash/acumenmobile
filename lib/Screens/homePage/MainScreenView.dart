import 'dart:io';

import 'package:acumenmobile/Routes/goToRoutes.dart';
import 'package:acumenmobile/Screens/homePage/HomeScreen.dart';
import 'package:acumenmobile/Screens/loginPage/loginScreen.dart';
import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/modal/chartData.dart';
import 'package:acumenmobile/reusableComponents/homePageCard.dart';
import 'package:acumenmobile/reusableComponents/primaryButton.dart';
import 'package:acumenmobile/reusableFunction/createImageStream.dart';
import 'package:acumenmobile/reusableFunction/loadTflifeModel.dart';
import 'package:acumenmobile/reusableFunction/saveHistory.dart';
import 'package:acumenmobile/reusableFunction/uploadImageFirebase.dart';
import 'package:acumenmobile/utils/const.dart';
import 'package:export_video_frame/export_video_frame.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite/tflite.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/// Content OF Home SCreen will be displayed in this Page
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
  bool videoSelected = false;
  bool loading = false;

  List<ChartComponent> emotionOutput = [];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  void pickImage({ImageSource imageSource = ImageSource.gallery}) {
    ImagePicker()
        .pickImage(
      source: imageSource,
    )
        .then(
      (value) async {
        // Navigator.of(context).pop();
        setState(() {
          imagesStream = createImageStream(xFile: value);
          videoSelected = true;
        });
      },
    );
  }

  void pickVideo({
    ImageSource imageSource = ImageSource.gallery,
    Duration? duration,
  }) {
    ImagePicker()
        .pickVideo(
      source: ImageSource.gallery,
      maxDuration: duration ??
          Duration(
            seconds: 30,
          ),
    )
        .then((value) {
      setState(() {
        // Navigator.of(context).pop();
        imagesStream = ExportVideoFrame.exportImagesFromFile(
          File(value!.path),
          const Duration(seconds: 10),
          0,
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    faceDetector.close();
    imageLabeler.close();
    // Tflite.close();
  }

  Future<List<dynamic>?> getFaceResult({required InputImage inputImage}) async {
    var prediction =
        await Tflite.runModelOnImage(path: inputImage.filePath.toString());
    prediction!.forEach((element) {
      print("Element is $element");
    });
    print(prediction);
    prediction.forEach((element) {
      dataForFirebase.add(element);
    });
    return prediction;
  }

  var dataForFirebase = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFc6dcfa),
      child: SingleChildScrollView(
        child: Container(
          height: height * 1.6,
          // height: height * 0.7,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<File>(
                  stream: imagesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // if (videoSelected) {
                      //   return Text("Video selected");
                      // }
                      return FutureBuilder<List<dynamic>?>(
                        initialData: [],
                        future: getFaceResult(
                          inputImage: InputImage.fromFilePath(
                            snapshot.data!.path,
                          ),
                        ),
                        builder: (context, imageListSnapshot) {
                          if (imageListSnapshot.hasData) {
                            List<ChartComponent>? imageList = [];
                            imageListSnapshot.data!.forEach((element) {
                              // dataForFirebase.add(element);
                              imageList.add(ChartComponent(
                                name: element['label'].toString(),
                                confidence: double.parse(
                                    element["confidence"].toString()),
                              ));
                              // imageList.add(ChartComponent(
                              //   name: element['label'],
                              //   confidence: element["confidence"],
                              // ));
                            });
                            return Column(
                              // clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  height: 300,
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

                                if (imageListSnapshot.data!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Emotion and Behavior detected ${imageListSnapshot.data!.first['label'].toString().substring(2)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                if (imageListSnapshot.data!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Confidence Score ${imageListSnapshot.data![0]['confidence'].toString()}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                SfCircularChart(
                                  series: <CircularSeries>[
                                    RadialBarSeries<ChartComponent, String>(
                                      dataSource: imageList.toList(),
                                      enableTooltip: true,
                                      legendIconType: LegendIconType.circle,
                                      dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        labelIntersectAction:
                                            LabelIntersectAction.shift,
                                      ),
                                      maximumValue: 1.0,
                                      radius: '100%',
                                      gap: '4%',
                                      xValueMapper: (ChartComponent data, _) =>
                                          data.name,
                                      yValueMapper: (ChartComponent data, _) =>
                                          data.confidence,
                                      sortingOrder: SortingOrder.descending,
                                      cornerStyle: CornerStyle.bothCurve,
                                    )
                                  ],
                                  annotations: [
                                    CircularChartAnnotation(
                                      widget: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(300),
                                          child: Image.file(
                                            File(snapshot.data!.path),
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ],
                                  title: ChartTitle(
                                    text: "Result",
                                  ),
                                  legend: Legend(
                                    isVisible: true,
                                    image: FileImage(File(snapshot.data!.path)),
                                    isResponsive: true,
                                    title: LegendTitle(
                                      text: "Behavior",
                                      textStyle: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  backgroundColor: Colors.white12,
                                ),

                                PrimaryButton(
                                  text: "Create Report",
                                  onTap: () async {
                                    //Create a new PDF document
                                    PdfDocument document = PdfDocument();

                                    //Adds a page to the document
                                    PdfPage page = document.pages.add();

                                    //Draw the image
                                    page.graphics.drawImage(
                                        PdfBitmap(File(snapshot.data!.path)
                                            .readAsBytesSync()),
                                        Rect.fromLTWH(
                                            0,
                                            0,
                                            page.getClientSize().width,
                                            page.getClientSize().height / 3));

                                    List<String> pdfcollection = [];
                                    dataForFirebase.forEach((element) {
                                      pdfcollection.add(
                                        element["label"]
                                                .toString()
                                                .substring(2) +
                                            " ${element["confidence"].toString()}",
                                      );
                                    });
                                    PdfOrderedList(
                                            items: PdfListItemCollection(
                                              pdfcollection,
                                            ),
                                            font: PdfStandardFont(
                                              PdfFontFamily.helvetica,
                                              20,
                                              style: PdfFontStyle.regular,
                                            ),
                                            indent: 20,
                                            format: PdfStringFormat(
                                              lineSpacing: 10,
                                            ))
                                        .draw(
                                            page: page,
                                            bounds: Rect.fromLTWH(0, 20, 0, 0));

                                    PdfDateTimeField dateAndTimeField =
                                        PdfDateTimeField(
                                            font: PdfStandardFont(
                                                PdfFontFamily.helvetica, 19),
                                            brush: PdfSolidBrush(
                                                PdfColor(0, 0, 0)));
                                    dateAndTimeField.date = DateTime(
                                        2020, 2, 10, 13, 13, 13, 13, 13);
                                    dateAndTimeField.dateFormatString =
                                        'E, MM.dd.yyyy';

                                    //Create the footer with specific bounds
                                    PdfPageTemplateElement footer =
                                        PdfPageTemplateElement(Rect.fromLTWH(
                                            0,
                                            0,
                                            document.pages[0]
                                                .getClientSize()
                                                .width,
                                            50));

                                    //Create the page number field
                                    PdfPageNumberField pageNumber =
                                        PdfPageNumberField(
                                            font: PdfStandardFont(
                                                PdfFontFamily.timesRoman, 19),
                                            brush: PdfSolidBrush(
                                                PdfColor(0, 0, 0)));

                                    //Sets the number style for page number
                                    pageNumber.numberStyle =
                                        PdfNumberStyle.upperRoman;

                                    //Create the page count field
                                    PdfPageCountField count = PdfPageCountField(
                                        font: PdfStandardFont(
                                            PdfFontFamily.helvetica, 19),
                                        brush:
                                            PdfSolidBrush(PdfColor(0, 0, 0)));

                                    //set the number style for page count
                                    count.numberStyle =
                                        PdfNumberStyle.upperRoman;

                                    //Create the date and time field
                                    PdfDateTimeField dateTimeField =
                                        PdfDateTimeField(
                                            font: PdfStandardFont(
                                                PdfFontFamily.helvetica, 19),
                                            brush: PdfSolidBrush(
                                                PdfColor(0, 0, 0)));

                                    //Sets the date and time
                                    dateTimeField.date = DateTime.now();

                                    //Sets the date and time format
                                    dateTimeField.dateFormatString =
                                        'hh\':\'mm\':\'ss';

                                    //Create the composite field with page number page count
                                    PdfCompositeField compositeField =
                                        PdfCompositeField(
                                            font: PdfStandardFont(
                                                PdfFontFamily.helvetica, 19),
                                            brush: PdfSolidBrush(
                                                PdfColor(0, 0, 0)),
                                            text: 'Page {0} of {1}, Time:{2}',
                                            fields: <PdfAutomaticField>[
                                          pageNumber,
                                          count,
                                          dateTimeField
                                        ]);
                                    compositeField.bounds = footer.bounds;

                                    //Add the composite field in footer
                                    compositeField.draw(
                                        footer.graphics,
                                        Offset(
                                            290,
                                            50 -
                                                PdfStandardFont(
                                                        PdfFontFamily
                                                            .timesRoman,
                                                        19)
                                                    .height));

//Add the footer at the bottom of the document
                                    document.template.bottom = footer;

                                    //Save the document
                                    List<int> bytes = document.save();

                                    //Get external storage directory
                                    final directory =
                                        await getExternalStorageDirectory();

//Get directory path
                                    final path = directory!.path;

                                    //Create an empty file to write PDF data
                                    File file = File('$path/Output1.pdf');

//Write PDF data
                                    await file.writeAsBytes(bytes, flush: true);

                                    print("path is $path/output.pdf");

                                    //Open the PDF document in mobile
                                    OpenFile.open('$path/Output1.pdf');

                                    //Disposes the document
                                    document.dispose();
                                  },
                                ),
                                FirebaseAuth.instance.currentUser != null
                                    ? StatefulBuilder(
                                        builder: (context, statefulBuilder) {
                                        return loading
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: SizedBox(
                                                    child:
                                                        CircularProgressIndicator()),
                                              )
                                            : PrimaryButton(
                                                text: "Save Data ",
                                                onTap: () async {
                                                  statefulBuilder.call(() {});
                                                  statefulBuilder.call(() {
                                                    loading = true;
                                                  });
                                                  uploadImagetFirebase(
                                                          snapshot.data!.path)
                                                      .then((value) async {
                                                    if (value != null) {
                                                      await saveHistory(
                                                          historyData: {
                                                            "data":
                                                                dataForFirebase,
                                                            "time":
                                                                DateTime.now(),
                                                            "image": value,
                                                          }).then((value) {
                                                        statefulBuilder(() {
                                                          loading = false;
                                                        });
                                                      });
                                                    }
                                                  });
                                                },
                                              );
                                      })
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                tweenNavigation(
                                                  nextScreen: LoginScreen(),
                                                ),
                                              );
                                            },
                                            child:
                                                Text("Login to Save History")),
                                      ),

                                // Positioned(child: ),

                                // Positioned(
                                //   bottom: -120,
                                //   left: -5,
                                //   child: StreamBuilder<List<Face>>(
                                //     stream: detectFaces(
                                //       inputImage: InputImage.fromFilePath(
                                //         snapshot.data!.path,
                                //       ),
                                //     ).asStream(),
                                //     builder: (context, faceResult) {
                                //       if (faceResult.hasData) {
                                //         if (faceResult.data!.length == 0) {
                                //           return Container(
                                //             padding: const EdgeInsets.all(8.0),
                                //             child: Text(
                                //               faceResult.data.toString(),
                                //             ),
                                //           );
                                //         }
                                //         return Flex(
                                //           direction: Axis.vertical,
                                //           children: faceResult.data!.map(
                                //             (face) {
                                //               return Container(
                                //                 padding: EdgeInsets.all(9),
                                //                 width: width,
                                //                 child: Card(
                                //                   child: Flex(
                                //                     direction: Axis.vertical,
                                //                     children: [
                                //                       Container(
                                //                         padding: EdgeInsets.all(10),
                                //                         width: width,
                                //                         child: Wrap(
                                //                           children: [
                                //                             Text(
                                //                               "Face Bounding Position",
                                //                             ),
                                //                             Text(
                                //                               face.boundingBox
                                //                                   .toString(),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ),
                                //                       Container(
                                //                         padding: EdgeInsets.all(10),
                                //                         width: width,
                                //                         child: Wrap(
                                //                           children: [
                                //                             Text("Emotion: "),
                                //                             Text(
                                //                               face.smilingProbability !=
                                //                                       null
                                //                                   ? calculateSmile(
                                //                                       smilingProbability:
                                //                                           face.smilingProbability,
                                //                                     )
                                //                                   : "",
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //               );
                                //             },
                                //           ).toList(),
                                //         );
                                //       } else {
                                //         return Padding(
                                //           padding: const EdgeInsets.all(8.0),
                                //           child: CircularProgressIndicator(),
                                //         );
                                //       }
                                //     },
                                //   ),
                                // ),

                                // Result of image ends here
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Please wait while we detect expression and behavior for you",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      backgroundColor: black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      );
                    } else {
                      return Container(
                        height: 800,
                        padding: const EdgeInsets.all(8.0),
                        child: Flex(
                          direction: Axis.vertical,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 40.0, left: 40.0, bottom: 10, top: 20),
                              child: Text(
                                "Welcome to Acumen",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0, left: 45.0, bottom: 70),
                              child: Text(
                                "Get Your Expression done in one tap",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GridView.count(
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 5,
                                childAspectRatio: 3.0,
                                scrollDirection: Axis.vertical,
                                crossAxisCount: 1,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      pickImage(
                                        imageSource: ImageSource.gallery,
                                      );
                                    },
                                    child: HomePageCard(
                                      iconData: CupertinoIcons.photo,
                                      title: "Gallery Image",
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      pickImage(
                                        imageSource: ImageSource.camera,
                                      );
                                    },
                                    child: HomePageCard(
                                      iconData: CupertinoIcons.camera,
                                      title: "Camera Image",
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      pickVideo(
                                        imageSource: ImageSource.gallery,
                                      );
                                    },
                                    child: HomePageCard(
                                      iconData: CupertinoIcons.video_camera,
                                      title: "Gallery Video",
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              // Spacer(),
              // PrimaryButton(
              //   text: "Run new Model",
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => CustomModelScreen(),
              //       ),
              //     );
              //   },
              // ),
              // PrimaryButton(
              //   text: "Reload Page ?",
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => HomePage(),
              //       ),
              //     );
              //   },
              // ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
