import 'package:acumenmobile/utils/const.dart';
import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final Color? color;
  final Rect rect;
  RectanglePainter({
    this.left,
    required this.rect,
    this.bottom,
    this.right,
    this.top,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = this.color ?? Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawRect(this.rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
