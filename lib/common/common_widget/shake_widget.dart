import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final double offset;
  final Duration duration;

  const ShakeWidget({
    super.key,
    required this.child,
    this.offset = 5,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void shake() {
    _controller.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -widget.offset), weight: 1),
      TweenSequenceItem(
        tween: Tween(begin: -widget.offset, end: widget.offset),
        weight: 2,
      ),
      TweenSequenceItem(tween: Tween(begin: widget.offset, end: 0), weight: 1),
    ]).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
