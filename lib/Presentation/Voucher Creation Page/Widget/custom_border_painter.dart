import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Paint _paint;

  DashedBorderPainter()
      : _paint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 8.0;
    double dashSpace = 4.0;
    double startX = 0;
    double startY = 0;

    // Top border (dashed)
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, startY), Offset(startX + dashWidth, startY), _paint);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    startY = size.height;

    // Bottom border (dashed)
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, startY), Offset(startX + dashWidth, startY), _paint);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    startY = 0;

    // Left border (dashed)
    while (startY < size.height) {
      canvas.drawLine(Offset(startX, startY), Offset(startX, startY + dashWidth), _paint);
      startY += dashWidth + dashSpace;
    }

    startX = size.width;
    startY = 0;

    // Right border (dashed)
    while (startY < size.height) {
      canvas.drawLine(Offset(startX, startY), Offset(startX, startY + dashWidth), _paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}