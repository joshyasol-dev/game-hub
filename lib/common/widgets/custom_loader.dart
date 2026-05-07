import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bybet_mini/common/styles.dart';

class CustomLoader extends CustomPainter {
  final double value;
  final double maxValue;

  CustomLoader(this.value, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    double diameter = min(size.height, size.width);
    double radius = diameter / 2;

    double pointX = 0;
    double pointY = diameter - ((diameter + 10) * (value / maxValue));

    Path path = Path();
    path.moveTo(pointX, pointY);

    double amplitude = 10;

    double period = value / maxValue;

    double phaseShift = value * pi;

    for (double i = 0; i <= diameter; i++) {
      path.lineTo(
        i + pointX,
        pointY + amplitude * sin((i * 2 * period * pi / diameter) + phaseShift),
      );
    }

    path.lineTo(pointX + diameter, diameter);
    path.lineTo(pointX, diameter);
    path.close();

    Paint paint = Paint()
      ..shader =
          const SweepGradient(
            colors: [
              AppStyles.darkPrimaryColor,
              Color.fromARGB(255, 76, 92, 63),
              Color.fromARGB(255, 72, 77, 67),
            ],
            startAngle: pi / 2,
            endAngle: 5 * pi / 2,
            tileMode: TileMode.clamp,
            stops: [0.25, 0.35, 0.5],
          ).createShader(
            Rect.fromCircle(center: Offset(diameter, diameter), radius: radius),
          )
      ..style = PaintingStyle.fill;

    // Clipping rectangular-shaped path to Oval.
    Path circleClip = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(radius, radius),
          width: diameter,
          height: diameter,
        ),
      );
    canvas.clipPath(circleClip, doAntiAlias: true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RadialProgressPainter extends CustomPainter {
  final double value;
  final List<Color> backGroundGradientColors;
  final double minValue;
  final double maxValue;

  RadialProgressPainter({
    required this.value,
    required this.backGroundGradientColors,
    required this.minValue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double diameter = min(size.height, size.width);
    final double radius = diameter / 2;
    final double centerX = radius;
    final double centerY = radius;

    const double strokeWidth = 6;

    final Paint progressPaint = Paint()
      ..shader =
          SweepGradient(
            colors: backGroundGradientColors,
            startAngle: -pi / 2,
            endAngle: 3 * pi / 2,
            tileMode: TileMode.repeated,
          ).createShader(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint progressTrackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi / 2;
    double sweepAngle = 2 * pi * value / maxValue;

    canvas.drawCircle(Offset(centerX, centerY), radius, progressTrackPaint);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}
