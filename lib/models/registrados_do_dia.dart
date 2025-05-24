class RegistradosDoDia {
  int id;
  int habitId;
  double completedToday;
  DateTime actualDay;
  int registerBy;


  RegistradosDoDia(
      {required this.id,
      required this.habitId,
      required this.actualDay,
       this.registerBy = 1,
      this.completedToday = 0});

  Map<String, dynamic> toMap() {
    return {
      'habitId': habitId,
      'completedToday': completedToday,
    };
  }

  static RegistradosDoDia fromMap(Map<dynamic, dynamic> map) {
    return RegistradosDoDia(
     id: map['id'],
     habitId: map['habitId'],
     completedToday: map['completedToday'],
     actualDay: DateTime.parse(map['actualDay']),
     registerBy: map['registeredBy']
    );
  }
}
