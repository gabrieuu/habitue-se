class HabitosRegistradosPercents {
  DateTime actualDay;
  double percentComplete;

  HabitosRegistradosPercents({required this.actualDay, required this.percentComplete});

  static HabitosRegistradosPercents fromJson(Map<String, dynamic> json){
    return HabitosRegistradosPercents(actualDay: DateTime.parse(json['actualDay']), percentComplete: json['percentComplete']);
  }

}