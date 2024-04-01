import 'dart:math';
import 'package:flutter/material.dart';

class ColorWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    // Рисуем цветовой круг
    for (double i = 0; i < 360; i += 0.1) {
      final double radian = i * pi / 180;
      final paint = Paint()
        ..color = HSVColor.fromAHSV(1.0, i, 1.0, 1.0).toColor()
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      final start = Offset(radius * cos(radian) + center.dx, radius * sin(radian) + center.dy);
      final end = Offset((radius - 20) * cos(radian) + center.dx, (radius - 20) * sin(radian) + center.dy);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
