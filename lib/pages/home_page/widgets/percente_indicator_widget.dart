import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PercentIndicatorWidget extends StatelessWidget {
  final Widget? child;
  final double? percent;
  final Color progressColor;
  final double? radius;
  final double? lineWidth;

  const PercentIndicatorWidget({
    Key? key,
    this.child,
    this.percent,
    this.progressColor = Colors.blue,
    this.radius,
    this.lineWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius ?? 20.0, // Tamanho do círculo
      percent: percent ?? 0.0, // Porcentagem de preenchimento
      lineWidth: lineWidth ?? 2.0, // Largura da barra
      center: child,
      progressColor: progressColor,
      backgroundColor: Colors.grey[200]!,
    );
  }
}
