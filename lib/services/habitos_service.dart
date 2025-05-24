import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/repository/abstract_habitos_repository.dart';
import 'package:habitue_se/shared/data_utils.dart';

class HabitosService {
  AbstractHabitosRepository habitosRepository;

  HabitosService(this.habitosRepository);

  List<Habito> getHabitosByData(DateTime date,
      {required List<Habito> listHabitos}) {
    if (listHabitos.isEmpty) {
      return [];
    }
    var list = (listHabitos)
        .where((element) =>
            _isDateWithinRange(date, element.startDate, element.endDate))
        .toList();
    return list;
  }

  bool _isDateWithinRange(
      DateTime date, DateTime startDate, DateTime? endDate) {
    if (endDate == null) {
      return date.isAfter(startDate) ||
          date.toFullYear().isAtSameMomentAs(startDate.toFullYear());
    }

    return (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
        (date.isBefore(endDate) || date.isAtSameMomentAs(endDate));
  }
}
