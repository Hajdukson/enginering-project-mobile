import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AnimatedTrendingUpIcon extends StatefulWidget {
  const AnimatedTrendingUpIcon({Key? key}) : super(key: key);

  @override
  State<AnimatedTrendingUpIcon> createState() => _AnimatedTrendingUpIconState();
}

class _AnimatedTrendingUpIconState extends State<AnimatedTrendingUpIcon> 
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1)
      );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}