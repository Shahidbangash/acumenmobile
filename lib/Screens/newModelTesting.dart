// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:acumenmobile/modal/chartData.dart';
import 'package:acumenmobile/reusableComponents/drawer.dart';
import 'package:acumenmobile/reusableComponents/primaryButton.dart';
import 'package:acumenmobile/reusableFunction/loadTflifeModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tflite/tflite.dart';

class CustomModelScreen extends StatefulWidget {
  CustomModelScreen({Key? key}) : super(key: key);

  @override
  _CustomModelScreenState createState() => _CustomModelScreenState();
}

class _CustomModelScreenState extends State<CustomModelScreen> {
  List<ChartComponent> chartData = [];
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> runModel() async {
    var image =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (image != null) {
      var prediction = await Tflite.runModelOnImage(
        path: image.path,
        threshold: 0.1,
      );
      prediction!.forEach((element) {
        setState(() {
          output = element['label'];
          chartData = [
            ChartComponent(
                name: element['label'].toString(),
                confidence: element['confidence']),
            ChartComponent(
                name: element['label'].toString(),
                confidence: element['confidence']),
            // ChartComponent(
            //     name: element['label'].toString(),
            //     confidence: element['confidence']),
          ];
        });
        print("element is $element['label']");
      });
    }
  }

  String output = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: CustomDrawer(),
        body: Column(
          children: [
            PrimaryButton(
              onTap: runModel,
              text: "Run Test",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Here is output $output"),
            ),
            SfCircularChart(series: <CircularSeries>[
              RadialBarSeries<ChartComponent, String>(
                dataSource: chartData,
                name: "Emotion",
                legendIconType: LegendIconType.diamond,
                maximumValue: 1.0,
                radius: '100%',
                gap: '3%',
                // useSeriesColor: true,
                xValueMapper: (ChartComponent data, _) => data.name,
                yValueMapper: (ChartComponent data, _) => data.confidence,
                sortingOrder: SortingOrder.descending,

                // Corner style of radial bar segment
                cornerStyle: CornerStyle.bothCurve,
              )
            ]),
          ],
        ));
  }
}
