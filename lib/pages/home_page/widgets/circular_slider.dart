import 'dart:math';

import 'package:flutter/material.dart';

class CircularSlider extends StatefulWidget {
  @override
  _CircularSliderScreenState createState() => _CircularSliderScreenState();
}

class _CircularSliderScreenState extends State<CircularSlider> {
  double _percentage = 100; // Valor inicial (50%)

  void _updateSlider(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;

    double angle = atan2(dy, dx); // Calcula o ângulo baseado no toque

    double newPercentage = ((angle + pi) / (2 * pi)) * 100;
    newPercentage =
        newPercentage.clamp(0, 100); // Garante que fique entre 0 e 100
    
    setState(() {
      _percentage = newPercentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Slider Circular Manual")),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (details) {
            RenderBox box = context.findRenderObject() as RenderBox;
            _updateSlider(box.globalToLocal(details.globalPosition), box.size);
          },
          child: CustomPaint(
            size: Size(250, 250), // Tamanho do círculo
            painter: CircularSliderPainter(_percentage),
          ),
        ),
      ),
    );
  }
}

class CircularSliderPainter extends CustomPainter {
  final double percentage;

  CircularSliderPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final Paint trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final Paint progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final Paint knobPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    // Desenha o círculo base (trilha)
    canvas.drawCircle(center, radius, trackPaint);

    // Converte a porcentagem para um ângulo em radianos
    double angle = (percentage / 100) * (2 * pi) - pi;

    // Desenha o progresso do slider
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi, // Começa do lado esquerdo
      angle + pi, // Progresso baseado na porcentagem
      false,
      progressPaint,
    );

    // Calcula a posição do "knob" (botão de controle)
    final knobX = center.dx + radius * cos(angle);
    final knobY = center.dy + radius * sin(angle);

    // Desenha o botão de controle
    canvas.drawCircle(Offset(knobX, knobY), 20, knobPaint);

    // Exibe o valor da porcentagem no centro do círculo
    final textPainter = TextPainter(
      text: TextSpan(
        text: "${percentage}%",
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CircularSliderPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
