import 'package:flutter/material.dart';
import 'package:habitue_se/models/response/habitos_registrados_percents.dart';
import 'package:habitue_se/shared/data_utils.dart';

class CalendarState extends ValueNotifier<List<HabitosRegistradosPercents>>{

  CalendarState(super.value);

  HabitosRegistradosPercents habitoCompleteByData(DateTime day) => value.firstWhere((e) => e.actualDay.isSameDate(day), orElse: () => HabitosRegistradosPercents(actualDay: day, percentComplete: 0),);
}