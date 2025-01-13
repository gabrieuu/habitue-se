import 'dart:math';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/percent_color.dart';
import 'package:habitue_se/shared/data_utils.dart';
import 'dart:ui';

import 'package:habitue_se/shared/temas.dart';

class TimelineCalendar extends StatelessWidget {
  TimelineCalendar({super.key});

  final HomeController controller = GetIt.instance<HomeController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return EasyDateTimeLinePicker.itemBuilder(
            firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
            lastDate:
                DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
            focusedDate: DateTime.now(),
            itemExtent: 60,
            headerOptions: HeaderOptions(headerType: HeaderType.none),
            onDateChange: (date) {},
            itemBuilder: (context, date, isSelected, _, __, onTap) {
              isSelected = date.isSameDate(DateTime.now());
              return _buildDayTile(date, isSelected, onTap);
            },
          );
        });
  }

  Widget _buildDayTile(DateTime date, bool isSelected, void Function() onTap) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 70,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected ? Temas.blackColor : Colors.transparent,
            border: Border.all(
              color: Temas.blackColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dayByInt(date.weekday).substring(0, 3),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (date.isBefore(DateTime.now()))
          CustomPaint(
            size: const Size(50, 70),
            painter: _MyBorderPainter(
                progress: controller.getPercentCompletado(date),
                borderColor:
                    percentColor(controller.getPercentCompletado(date))),
          ),
      ],
    );
  }
}

class _MyBorderPainter extends CustomPainter {
  _MyBorderPainter(
      {required this.progress, required this.borderColor, this.strokeWdth});
  double progress; // desirable value for corners side
  double? strokeWdth;
  Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    double x = min(size.height, size.width);
    double x2 = x / 2;
    double x4 = x / 4;

    Paint paintt = Paint()
      ..color = progress == 0 ? Colors.transparent : borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWdth ?? 4.0;
    // ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(size.width / 2, 0) // Começa no centro superior
      ..lineTo(size.width - size.width * 0.1,
          0) // Linha reta até o ponto antes do canto superior direito
      ..quadraticBezierTo(size.width, 0, size.width,
          size.height * 0.1) // Curva no canto superior direito
      ..lineTo(
          size.width,
          size.height -
              size.height *
                  0.1) // Linha reta até o ponto antes do canto inferior direito
      ..quadraticBezierTo(
          size.width,
          size.height,
          size.width - size.width * 0.1,
          size.height) // Curva no canto inferior direito
      ..lineTo(size.width * 0.1,
          size.height) // Linha reta até o ponto antes do canto inferior esquerdo
      ..quadraticBezierTo(0, size.height, 0,
          size.height - size.height * 0.1) // Curva no canto inferior esquerdo
      ..lineTo(
          0,
          size.height *
              0.1) // Linha reta até o ponto antes do canto superior esquerdo
      ..quadraticBezierTo(
          0, 0, size.width * 0.1, 0) // Curva no canto superior esquerdo
      ..lineTo(size.width / 2, 0) // Fecha o caminho de volta ao ponto inicial
      ..close();

    PathMetric pathMetric = path.computeMetrics().first;

// Ajusta a extração para começar do topo central e seguir no sentido horário
    Path extractPath = pathMetric.extractPath(
        pathMetric.length * (1 - progress), pathMetric.length);
    canvas.drawPath(extractPath, paintt);
  }

  @override
  bool shouldRepaint(covariant _MyBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class SquareProgressBar extends StatelessWidget {
  const SquareProgressBar(
      {required this.strokeWdth,
      required this.borderColor,
      this.borderBgColor,
      required this.progress,
      this.child,
      Key? key})
      : super(key: key);
  final double strokeWdth;
  final Color borderColor;
  final Color? borderBgColor;
  final double progress;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: _MyBorderPainter(
            borderColor: borderBgColor ?? Colors.grey,
            strokeWdth: strokeWdth,
            progress: 1.0),
        child: CustomPaint(
          painter: _MyBorderPainter(
            progress: this.progress,
            borderColor: borderColor,
            strokeWdth: strokeWdth,
          ),
          child: this.child ?? null,
        ));
  }
}

String dayByInt(int dia) {
  switch (dia) {
    case 1:
      return 'Segunda-feira';
    case 2:
      return 'Terça-feira';
    case 3:
      return 'Quarta-feira';
    case 4:
      return 'Quinta-feira';
    case 5:
      return 'Sexta-feira';
    case 6:
      return 'Sábado';
    case 7:
      return 'Domingo';
    default:
      return 'Valor inválido';
  }
}
