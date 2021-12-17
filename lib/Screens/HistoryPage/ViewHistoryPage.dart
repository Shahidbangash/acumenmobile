import 'dart:developer';
import 'dart:io';
import 'dart:io';
import 'package:acumenmobile/reusableComponents/primaryButton.dart';
import 'package:acumenmobile/reusableFunction/generateReportHistory.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:acumenmobile/Theme/colors.dart';
import 'package:acumenmobile/modal/chartData.dart';
import 'package:acumenmobile/reusableComponents/TopBarContainer.dart';
import 'package:acumenmobile/reusableComponents/confirmationDialog.dart';
import 'package:acumenmobile/reusableFunction/FirebaseAuthentication.dart';
import 'package:acumenmobile/reusableFunction/deleteItemFirebase.dart';
import 'package:acumenmobile/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ViewHistoryScreen extends StatefulWidget {
  ViewHistoryScreen({Key? key}) : super(key: key);

  @override
  _ViewHistoryScreenState createState() => _ViewHistoryScreenState();
}

class _ViewHistoryScreenState extends State<ViewHistoryScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
          // direction: Axis.vertical,
          children: [
            Flexible(
              flex: 2,
              child: TopBarDecoration(
                backgroundColor: primaryColorAndPrimaryButtonColor,
                title: "History",
                widget: Container(),
              ),
            ),
            user != null
                ? Flexible(
                    flex: 7,
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("history")
                              .where("userId", isEqualTo: getCurrentUser()!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("You have not added any history"),
                                );
                              }
                              return Column(
                                children: snapshot.data!.docs.map((e) {
                                  // var date = e.get('time');
                                  // Timestamp dateTime = e.get('time');
                                  // dateTime.toDate();
                                  List<ChartComponent> chartCompentList = [];
                                  List<String> labelList = [];
                                  List.from(e.get("data")).forEach((element) {
                                    // print(element);
                                    chartCompentList.add(ChartComponent(
                                        name: element['label'].toString(),
                                        confidence: double.parse(
                                          element['confidence']
                                              .toString()
                                              .substring(0, 4),
                                        )));
                                    labelList.add(
                                      "${element['label'].toString().substring(2)} ${element['confidence'].toString().substring(0, 4)}%",
                                    );
                                  });

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(22)),
                                      elevation: 10,
                                      child: Column(
                                        children: [
                                          SfCircularChart(
                                            series: <CircularSeries>[
                                              RadialBarSeries<ChartComponent,
                                                  String>(
                                                dataSource: chartCompentList,
                                                enableTooltip: true,
                                                legendIconType:
                                                    LegendIconType.circle,
                                                dataLabelSettings:
                                                    DataLabelSettings(
                                                  isVisible: true,
                                                  labelIntersectAction:
                                                      LabelIntersectAction
                                                          .shift,
                                                ),
                                                // maximumValue: 1.0,
                                                radius: '100%',
                                                gap: '4%',
                                                xValueMapper:
                                                    (ChartComponent data, _) =>
                                                        data.name,
                                                yValueMapper:
                                                    (ChartComponent data, _) =>
                                                        data.confidence,
                                                sortingOrder:
                                                    SortingOrder.descending,
                                                cornerStyle:
                                                    CornerStyle.bothCurve,
                                              )
                                            ],
                                            annotations: [
                                              CircularChartAnnotation(
                                                widget: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          300),
                                                  child: Image.network(
                                                    e.data().containsKey(
                                                            'image')
                                                        ? e.get("image")
                                                        : placeholerImageLink,
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            title: ChartTitle(
                                              text: "Result",
                                            ),
                                            legend: Legend(
                                              isVisible: true,
                                              image: NetworkImage(
                                                e.data().containsKey('image')
                                                    ? e.get("image")
                                                    : placeholerImageLink,
                                              ),
                                              isResponsive: true,
                                              title: LegendTitle(
                                                text: "Behavior",
                                                textStyle:
                                                    TextStyle(fontSize: 17),
                                              ),
                                            ),
                                            backgroundColor: Colors.white30,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: PrimaryButton(
                                              buttonColor: Colors.redAccent,
                                              onTap: () {
                                                showCustomDialog(
                                                    context: context,
                                                    title:
                                                        Text("Confirmation !"),
                                                    content: Text(
                                                        "Do you want to delete this"),
                                                    buttonList: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("No"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          deleteHistoryFirebase(
                                                                  id: e.id)
                                                              .then((value) {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: Text("Yes"),
                                                      )
                                                    ]);
                                              },
                                              text: "Delete History",
                                              textColor: whiteColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: PrimaryButton(
                                              text: "Generate PDF",
                                              onTap: () {
                                                generatePDFFromHistory(
                                                  imageUrl: e
                                                          .data()
                                                          .containsKey('image')
                                                      ? e.get("image")
                                                      : placeholerImageLink,
                                                  labelList: labelList,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                    ),
                  )
                : Flexible(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You have No History yet",
                      ),
                    ),
                  ),
          ]),
    );
  }
}
