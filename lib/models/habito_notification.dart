import 'package:flutter/material.dart';

class HabitoNotification {
  List<int> daysOfWeek;
  TimeOfdayHabitos? horarioFixo;
  List<TimeOfdayHabitos> horariosVariados;

  HabitoNotification({
    this.daysOfWeek = const [],
    this.horariosVariados = const [],
    this.horarioFixo,
  }) {
    if (daysOfWeek.isEmpty) {
      daysOfWeek = [1, 2, 3, 4, 5, 6, 7];
    }
    if (horariosVariados.isEmpty) {
      horariosVariados = [
        TimeOfdayHabitos(hour: 8, minute: 0),
        TimeOfdayHabitos(hour: 12, minute: 0),
        TimeOfdayHabitos(hour: 18, minute: 0),
      ];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'days_of_week': daysOfWeek,
      'horarioFixo': horarioFixo?.toMap(),
      'horariosVariados': horariosVariados.map((e) => e.toMap()).toList(),
    };
  }

  factory HabitoNotification.fromMap(Map<dynamic, dynamic> map) {
    return HabitoNotification(
      daysOfWeek:
          (map['days_of_week'] as List<int>).map((e) => e.toInt()).toList(),
      horarioFixo: map['horarioFixo'] != null
          ? TimeOfdayHabitos.fromMap(map['horarioFixo'])
          : null,
      horariosVariados: map['horariosVariados'] != null
          ? (map['horariosVariados'] as List<dynamic>)
              .map<TimeOfdayHabitos>((e) => TimeOfdayHabitos.fromMap(e))
              .toList()
          : [],
    );
  }

  bool shouldTriggerNotification({DateTime? currentDateTime}) {
    DateTime now = currentDateTime ?? DateTime.now();

    int currentDay = now.weekday;

    return daysOfWeek.contains(currentDay);
  }
}

class TimeOfdayHabitos {
  final int hour;
  final int minute;

  TimeOfdayHabitos({required this.hour, required this.minute});

  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minute': minute,
    };
  }

  factory TimeOfdayHabitos.fromMap(Map<dynamic, dynamic> map) {
    return TimeOfdayHabitos(
      hour: map['hour'],
      minute: map['minute'],
    );
  }

  static TimeOfdayHabitos timeOfDayToTimeOfdayHabitos(TimeOfDay timeOfDay) {
    return TimeOfdayHabitos(hour: timeOfDay.hour, minute: timeOfDay.minute);
  }

  TimeOfDay get timeOfdayHabitosToTimeOfDay {
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeOfdayHabitos &&
          runtimeType == other.runtimeType &&
          hour == other.hour &&
          minute == other.minute;

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;

  @override
  String toString() {
    String hourString = hour.toString().padLeft(2, '0');
    String minuteString = minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }
}
