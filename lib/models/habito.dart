import 'package:habitue_se/models/habito_notification.dart';
class Habito {
  int id;
  String unicodeEmoji;
  String name;
  String description;
  String unitOfMeasure;
  double dailyGoal;
  DateTime startDate;
  DateTime? endDate;
  String hexColor;
  HabitoNotification habitoNotification;

  Habito({
    required this.id,
    required this.unicodeEmoji,
    required this.name,
    required this.description,
    required this.unitOfMeasure,
    required this.dailyGoal,
    required this.startDate,
    required this.habitoNotification,
    this.endDate,
    required this.hexColor,
  });

  factory Habito.fromJson(Map<String, dynamic> json) {
    return Habito(
      id: json['id'],
      unicodeEmoji: json['unicodeEmoji'],
      name: json['name'],
      description: json['description'],
      unitOfMeasure: json['unitOfMeasure'],
      dailyGoal: json['dailygoal'].toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      hexColor: json['hexColor'],
      habitoNotification: (json['habito_notification'] != null)
          ? HabitoNotification.fromMap(json['habito_notification'])
          : HabitoNotification(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unicodeEmoji': unicodeEmoji,
      'name': name,
      'description': description,
      'unitOfMeasure': unitOfMeasure,
      'dailygoal': dailyGoal,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'hexColor': hexColor,
    };
  }

  @override
  int get hashCode => id.hashCode;

  @override
  operator ==(other) => other is Habito && other.id == id;

}
