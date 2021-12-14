import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartComponent {
  final String name;
  Color? color;
  final double confidence;
  // ['Low', 3500, const Color.fromRGBO(235, 97, 143, 1)],
  ChartComponent({
    required this.name,
    this.color,
    required this.confidence,
  });
}
