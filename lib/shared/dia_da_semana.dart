const Map<int, String> diasSemana = {
  DateTime.monday: 'Segunda-feira',
  DateTime.tuesday: 'Terça-feira',
  DateTime.wednesday: 'Quarta-feira',
  DateTime.thursday: 'Quinta-feira',
  DateTime.friday: 'Sexta-feira',
  DateTime.saturday: 'Sábado',
  DateTime.sunday: 'Domingo',
};

const Map<int, String> mesesDoAno = {
  DateTime.january: 'Janeiro',
  DateTime.february: 'Fevereiro',
  DateTime.march: 'Março',
  DateTime.april: 'Abril',
  DateTime.may: 'Maio',
  DateTime.june: 'Junho',
  DateTime.july: 'Julho',
  DateTime.august: 'Agosto',
  DateTime.september: 'Setembro',
  DateTime.october: 'Outubro',
  DateTime.november: 'Novembro',
  DateTime.december: 'Dezembro',
};

String diaDaSemana(int dia) {
  return diasSemana[dia]!;
}

String mesDoAno(int mes) {
  return mesesDoAno[mes]!;
}
