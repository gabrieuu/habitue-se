import 'package:flutter/material.dart';
import 'package:habitue_se/models/habito_notification.dart';
import 'package:habitue_se/pages/adicionar_novo_habito/novo_habito_view_controller.dart';
import 'package:habitue_se/shared/dia_da_semana.dart';
import 'package:habitue_se/shared/temas.dart';

class AgendarHorarios extends StatefulWidget {
  const AgendarHorarios({super.key, required this.controller});

  final NovoHabitoViewController controller;

  @override
  _AgendarHorariosState createState() => _AgendarHorariosState();
}

class _AgendarHorariosState extends State<AgendarHorarios> {
  late List<TimeOfdayHabitos> selectedTime;
  late List<int> selectedDays;
  @override
  void initState() {
    super.initState();
    selectedTime = List<TimeOfdayHabitos>.from(widget.controller.selectedTime);
    selectedDays = List<int>.from(widget.controller.selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          widget.controller.setHorarios(selectedTime, selectedDays);
          if (mounted) Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Temas.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: const Text(
          'Salvar',
          style: TextStyle(
              fontSize: 15,
              color: Temas.backgroundColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      appBar: AppBar(
        title: const Text('Agendar Horários'),
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dias selecionados:', style: TextStyle(fontSize: 18)),
              Wrap(
                direction: Axis.horizontal,
                children: widget.controller.days
                    .map((day) => Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ChoiceChip(
                            label: Text(diaDaSemana(day)),
                            selected: selectedDays.contains(day),
                            onSelected: (bool value) {
                              if (selectedDays.contains(day)) {
                                selectedDays.remove(day);
                              } else {
                                selectedDays.add(day);
                              }
                              setState(() {});
                            },
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text('Horários das notificações (opcional):',
                  style: TextStyle(fontSize: 18)),
              if (selectedTime.isNotEmpty)
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedTime.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Temas.boxColor,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title:
                            Text('Horário: ${selectedTime[index].toString()}'),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                selectedTime.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.close)),
                        onTap: () => _selectTime(index: index),
                      ),
                    );
                  },
                ),
              Center(
                child: IconButton(
                    onPressed: _selectTime,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 35,
                    )),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _selectTime({int? index}) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (index != null)
          ? selectedTime[index].timeOfdayHabitosToTimeOfDay
          : TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (selectedTime.isNotEmpty &&
            selectedTime.contains(
                TimeOfdayHabitos.timeOfDayToTimeOfdayHabitos(picked))) {
          return;
        }

        if (index != null) {
          selectedTime[index] =
              TimeOfdayHabitos.timeOfDayToTimeOfdayHabitos(picked);
        } else {
          selectedTime
              .add(TimeOfdayHabitos.timeOfDayToTimeOfdayHabitos(picked));
        }
      });
    }
  }
}
