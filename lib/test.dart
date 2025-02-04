import 'package:flutter/material.dart';
import 'dart:math';

class WalkingManLoader extends StatefulWidget {
  const WalkingManLoader({super.key});

  @override
  State<WalkingManLoader> createState() => _WalkingManLoaderState();
}

class _WalkingManLoaderState extends State<WalkingManLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: WalkingManPainter(_animation.value),
          );
        },
      ),
    );
  }
}

class WalkingManPainter extends CustomPainter {
  final double progress;
  final Paint _paint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  WalkingManPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    _drawBody(canvas);
    _drawArms(canvas);
    _drawLegs(canvas);
    _drawPullingLine(canvas, size);
    _drawHead(canvas);
  }

  void _drawHead(Canvas canvas) {
    // Head
    canvas.drawCircle(const Offset(30, 30), 10, _paint..style = PaintingStyle.fill);
  }

  void _drawBody(Canvas canvas) {
    // Torso
    canvas.drawRect(const Rect.fromLTWH(25, 40, 10, 40), _paint..style = PaintingStyle.fill);
  }

  void _drawArms(Canvas canvas) {
    final armLength = 20.0;
    final shoulderHeight = 70.0;

    // Left arm
    final leftArmAngle = -pi/4 + (pi/3) * progress;
    final leftShoulder =  Offset(25, shoulderHeight);
    final leftHand = leftShoulder + Offset(armLength * cos(leftArmAngle), armLength * sin(leftArmAngle));
    canvas.drawLine(leftShoulder, leftHand, _paint..strokeWidth = 4);

    // Right arm
    final rightArmAngle = -pi/4 + (pi/3) * (1 - progress);
    final rightShoulder =  Offset(35, shoulderHeight);
    final rightHand = rightShoulder + Offset(armLength * cos(rightArmAngle), armLength * sin(rightArmAngle));
    canvas.drawLine(rightShoulder, rightHand, _paint..strokeWidth = 4);
  }

  void _drawLegs(Canvas canvas) {
    final legLength = 25.0;
    final hipHeight = 80.0;

    // Left leg
    final leftLegAngle = pi/6 - (pi/4) * progress;
    final leftHip =  Offset(30, hipHeight);
    final leftFoot = leftHip + Offset(legLength * cos(leftLegAngle), legLength * sin(leftLegAngle));
    canvas.drawLine(leftHip, leftFoot, _paint..strokeWidth = 4);

    // Right leg
    final rightLegAngle = pi/6 - (pi/4) * (1 - progress);
    final rightHip =  Offset(30, hipHeight);
    final rightFoot = rightHip + Offset(legLength * cos(rightLegAngle), legLength * sin(rightLegAngle));
    canvas.drawLine(rightHip, rightFoot, _paint..strokeWidth = 4);
  }

  void _drawPullingLine(Canvas canvas, Size size) {
    final lineY = 65.0;
    final startX = 30.0;
    final endX = startX + (size.width - 50) * progress;

    // Full line track
    canvas.drawLine(
      Offset(startX, lineY),
      Offset(size.width - 20, lineY),
      _paint..color = Colors.blue.withOpacity(0.2),
    );

    // Progress line
    canvas.drawLine(
      Offset(startX, lineY),
      Offset(endX, lineY),
      _paint..color = Colors.blue,
    );

    // Hands on line
    canvas.drawCircle(Offset(endX, lineY), 3, _paint..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(startX, lineY), 3, _paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(WalkingManPainter oldDelegate) => oldDelegate.progress != progress;
}