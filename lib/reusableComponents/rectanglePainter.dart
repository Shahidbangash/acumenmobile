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

    final a = Offset(size.width * 1 / 6, size.height * 1 / 4);
    final b = Offset(size.width * 5 / 6, size.height * 3 / 4);
    // final rect = Rect.fromPoints(a, b);
    // final rect = Rect.fromLTRB(left, top, right, bottom);
    // this.rect.

    canvas.drawRect(this.rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
