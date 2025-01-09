import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitue_se/models/tarefa.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/widgets/calendario_de_registos.dart';
import 'package:habitue_se/pages/home_page/widgets/lista_de_habitos.dart';
import 'package:habitue_se/repository/concrete_habitos_repository.dart';
import 'package:habitue_se/shared/bottom_app_bar_widget.dart';
import 'package:habitue_se/shared/status_enum.dart';
import 'package:habitue_se/shared/temas.dart';
import 'package:habitue_se/shared/widgets/timeline_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController controller = GetIt.instance<HomeController>();

  final List<Color> corAleatoria = [
    Temas.redSecondary,
    Temas.greenSecondary,
    Temas.blueSecondary,
    Temas.lilasSecondary,
    Temas.purpleSecondary,
    Temas.yellowSecondary,
  ];

  @override
  void initState() {
    super.initState();
    controller.getAllHabitos();
    controller.getAllTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Temas.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1)),
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) {
                      debugPrint('${controller.habitos}');
                      switch (controller.statusHabitosLoading) {
                        case StatusEnum.ERROR:
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Erro ao carregar os dados'),
                                const Gap(10),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.getAllHabitos();
                                  },
                                  child: const Text('Tentar novamente'),
                                )
                              ],
                            ),
                          );
                        case StatusEnum.SUCESS:
                          return _buildTela();
                        default:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                      }
                    }),
                const Gap(10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Tarefas',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Temas.blackColor),
                    ),
                  ),
                ),
                ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.tarefas.length,
                          itemBuilder: (context, index) {
                            return _buildListaDeTarefas(
                                controller.tarefas[index]);
                          },
                        ),
                      );
                    }),
                const Gap(20)
              ],
            )),
      ),
    );
  }

  Widget _buildListaDeTarefas(Tarefa tarefas) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return GestureDetector(
            onTap: () {
              controller.completarTarefa(tarefas);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: corAleatoria[controller.tarefas.indexOf(tarefas) % 6],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  tarefas.titulo,
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Temas.blackColor),
                ),
                trailing: Checkbox(
                  value: tarefas.completado,
                  onChanged: (value) {
                    controller.completarTarefa(tarefas);
                  },
                  activeColor: Temas.bluePrimary,
                ),
              ),
            ),
          );
        });
  }

  Widget _buildTela() {
    return Column(
      children: [
        const Gap(60),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Olá, Gabriel',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Temas.blackColor),
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              //color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: TimelineCalendar()),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chek-in Diário',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Temas.blackColor),
                ),
                Gap(5),
                Chip(padding: EdgeInsets.all(1), label: Text('Hoje'))
              ],
            ),
          ),
        ),
        ListaDeHabitos(),
      ],
    );
  }
}
