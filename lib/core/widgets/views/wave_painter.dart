import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color}); // Constructor me color lo

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color; // Dynamic color

    final path = Path();
    path.moveTo(0, 0); // Start from top-left
    path.lineTo(0, size.height * 0.6);

    // First small curve (left)
    path.quadraticBezierTo(
      size.width * 0.08, size.height * 0.80,
      size.width * 0.30, size.height * 0.60,
    );

    // Middle smooth bigger curve
    path.quadraticBezierTo(
      size.width * 0.48, size.height * 0.40,
      size.width * 0.60, size.height * 0.65,
    );

    // Right deep sharp curve
    path.quadraticBezierTo(
      size.width * 0.9, size.height * 1.2,
      size.width, size.height * 0.95,
    );

    path.lineTo(size.width, 0); // Top-right
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => oldDelegate.color != color;
}
