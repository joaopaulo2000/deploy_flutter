import 'package:flutter/material.dart';

class PointsCanvas extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xff000000)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    var paint1 = Paint()
      ..color = const Color(0xff0a2283)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 30;

    var points = [
      const Offset(200, 100),
      const Offset(200, 250),
      const Offset(130, 580),
      const Offset(50, 450),
      const Offset(80, 120),
      const Offset(110, 350),
      const Offset(320, 200),
      const Offset(350, 450),
      const Offset(200, 450),
      const Offset(50, 250),
    ];

    canvas.drawLine(
      const Offset(110, 350),
      const Offset(200, 100),
      paint,
    );

    canvas.drawLine(
      const Offset(200, 100),
      const Offset(320, 200),
      paint,
    );

    var labels = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "1",
      "2",
      "3",
      "4",
      "5",
    ];

    var additionalLabels = [
      "",
      "",
      "",
      "",
      "Fim",
      "Início",
      "",
      "",
      "",
      "",
    ];

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 8, paint1);
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: 100,
      );
      textPainter.paint(
        canvas,
        Offset(points[i].dx + 17, points[i].dy - 17),
      );

      if (additionalLabels[i].isNotEmpty) {
        final additionalTextPainter = TextPainter(
          text: TextSpan(
            text: additionalLabels[i],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        additionalTextPainter.layout(
          minWidth: 0,
          maxWidth: 100,
        );
        additionalTextPainter.paint(
          canvas,
          Offset(points[i].dx + 25, points[i].dy + 5),
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
