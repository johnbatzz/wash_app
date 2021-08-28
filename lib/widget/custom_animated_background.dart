import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAnimatedBackground extends StatefulWidget {
  CustomAnimatedBackgroundState createState() =>
      CustomAnimatedBackgroundState();
}

class CustomAnimatedBackgroundState extends State<CustomAnimatedBackground>
    with SingleTickerProviderStateMixin {
  ParticleOptions particleOptions = ParticleOptions(
    image: null,
    baseColor: Colors.blue,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.15,
    minOpacity: 0.1,
    maxOpacity: 0.4,
    spawnMinSpeed: 10.0,
    spawnMaxSpeed: 40.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 15.0,
    particleCount: 20,
  );

  var particlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  // Bubbles
  BubbleOptions _bubbleOptions = BubbleOptions();

  @override
  void initState() {
    super.initState();
    setState(() {
      _bubbleOptions = _bubbleOptions.copyWith(
          bubbleCount: 10, growthRate: 20, popRate: 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      behaviour: BubblesBehaviour(
        options: _bubbleOptions,
      ),
      vsync: this,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(),
        ),
      ),
    );
  }
}
