import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habitue_se/models/registrados_do_dia.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/percent_color.dart';
import 'package:habitue_se/pages/home_page/widgets/percente_indicator_widget.dart';
import 'package:habitue_se/repository/concrete_habitos_repository.dart';
import 'package:habitue_se/shared/temas.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioDeRegistros extends StatefulWidget {
  CalendarioDeRegistros({super.key, this.onDaySelected});

  void Function(DateTime, DateTime)? onDaySelected;
  @override
  State<CalendarioDeRegistros> createState() => _CalendarioDeRegistrosState();
}

class _CalendarioDeRegistrosState extends State<CalendarioDeRegistros> {
  HomeController controller = GetIt.instance<HomeController>();
  bool isExpanded = false;
  CalendarFormat calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1));
      },
      child: Column(
        children: [
          ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Temas.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.3,
                        blurRadius: 4,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                  child: TableCalendar(
                      locale: 'pt_BR',
                      calendarFormat: isExpanded
                          ? CalendarFormat.month
                          : CalendarFormat.week,
                      headerVisible: isExpanded ? true : false,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                      ),
                      onDaySelected: widget.onDaySelected,
                      availableGestures: AvailableGestures.all,
                      onFormatChanged: (format) {
                        setState(() {
                          calendarFormat = format;
                        });
                      },
                      currentDay: DateTime.now(),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          return (controller.getHabitosDoDia(day).isNotEmpty &&
                                  day.isBefore(DateTime.now()))
                              ? PercentIndicatorWidget(
                                  percent: controller.getTotalCompletado(
                                      controller.getHabitosDoDia(day)),
                                  progressColor: percentColor(
                                      controller.getTotalCompletado(
                                          controller.getHabitosDoDia(day))),
                                  child: Text('${day.day}'))
                              : Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Center(child: Text('${day.day}')));
                        },
                        todayBuilder: (context, day, focusedDay) {
                          return Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Temas.bluePrimary,
                                  borderRadius: BorderRadius.circular(50)),
                              alignment: Alignment.center,
                              child: Center(
                                  child: Text(
                                '${day.day}',
                                style: const TextStyle(
                                    color: Temas.backgroundColor),
                              )));
                        },
                      ),
                      focusedDay: DateTime.now(),
                      firstDay:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDay: DateTime.now().add(const Duration(days: 365))),
                );
              }),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Icon(isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down))
        ],
      ),
    );
  }
}
