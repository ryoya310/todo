import 'package:flutter/material.dart';
import 'dart:math' as math;

class RotatingCrystalIcon extends StatefulWidget {
  const RotatingCrystalIcon({Key? key}) : super(key: key);
  @override
  RotatingCrystalIconState createState() => RotatingCrystalIconState();
}

class RotatingCrystalIconState extends State<RotatingCrystalIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
    _animation = Tween(begin: 0.0, end: 2 * math.pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: Image.asset('lib/assets/images/logo.png'),
      builder: (context, child) {
        return Transform(
          // Y軸周りに回転
          transform: Matrix4.rotationY(_animation.value),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}