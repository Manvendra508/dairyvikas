import 'package:flutter/material.dart';

class StockLineIndicator extends StatelessWidget {
  final double value; // current value
  final double min; // min value
  final double max; // max value
  final Color activeColor;
  final Color inactiveColor;
  final double height;

  const StockLineIndicator({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final percent = ((value - min) / (max - min)).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: percent,
          backgroundColor: inactiveColor.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation(activeColor),
        ),
      ),
    );
  }
}
