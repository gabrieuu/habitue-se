import 'package:habitue_se/models/habito.dart';

abstract class NotificationEvents {
  final Habito habito;

  NotificationEvents(this.habito);
}

class NotificationEventHabitoCriado extends NotificationEvents {
  NotificationEventHabitoCriado(super.habito);
}

class NotificationEventHabitoApagado extends NotificationEvents {
  NotificationEventHabitoApagado(super.habito);
}

class NotificationEventHabitoFinalizado extends NotificationEvents {
  NotificationEventHabitoFinalizado(super.habito);
}
