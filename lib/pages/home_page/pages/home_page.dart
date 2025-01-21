import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitue_se/models/tarefa.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_controller.dart';
import 'package:habitue_se/pages/home_page/controller/home_controller.dart';
import 'package:habitue_se/pages/home_page/widgets/lista_de_habitos.dart';
import 'package:habitue_se/pages/home_page/widgets/progresso_hoje_widget.dart';
import 'package:habitue_se/shared/status_enum.dart';
import 'package:habitue_se/shared/temas.dart';
import 'package:habitue_se/shared/widgets/timeline_calendar.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController controller = GetIt.instance<HomeController>();
  BottomAppBarController bottomAppBarController =
      GetIt.instance<BottomAppBarController>();

  double titleSize = 17;

  @override
  void initState() {
    bottomAppBarController.currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Temas.backgroundColor,
      appBar: AppBar(
        backgroundColor: Temas.backgroundColor,
        forceMaterialTransparency: true,
        elevation: 0,
        title: const Column(
          children: [
            Text('Hoje',
                style: TextStyle(
                    color: Temas.blackColor, fontWeight: FontWeight.w600)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.sizeOf(context).height * 0.1),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: TimelineCalendar()),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await controller.init(),
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) {
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
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 20, vertical: 10),
                //     child: Text(
                //       'Tarefas',
                //       style: TextStyle(
                //           fontSize: titleSize,
                //           fontWeight: FontWeight.bold,
                //           color: Temas.blackColor),
                //     ),
                //   ),
                // ),
                // ListenableBuilder(
                //     listenable: controller,
                //     builder: (context, _) {
                //       return Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 16),
                //         child: ListView.builder(
                //           padding: const EdgeInsets.all(0),
                //           shrinkWrap: true,
                //           physics: const NeverScrollableScrollPhysics(),
                //           itemCount: controller.tarefas.length,
                //           itemBuilder: (context, index) {
                //             return _buildListaDeTarefas(
                //                 controller.tarefas[index]);
                //           },
                //         ),
                //       );
                //     }),
                // const Gap(20)
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
                color: Temas.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  tarefas.titulo,
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Temas.blackColor),
                ),
                trailing: Checkbox(
                  value: tarefas.completado,
                  onChanged: (value) {
                    controller.completarTarefa(tarefas);
                  },
                  activeColor: Colors.green,
                ),
              ),
            ),
          );
        });
  }

  Widget _buildTela() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (controller.getHabitosByData(controller.dataSelecionada).isNotEmpty)
          ProgressoHojeWidget(),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chek-in Diário',
                  style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Temas.blackColor),
                ),
                const Gap(5),
                const Chip(padding: EdgeInsets.all(1), label: Text('Hoje'))
              ],
            ),
          ),
        ),
        if (controller.getHabitosByData(controller.dataSelecionada).isEmpty)
          const LottieEmptyList(),
        if (controller.getHabitosByData(controller.dataSelecionada).isNotEmpty)
          ListaDeHabitos(),
      ],
    );
  }
}

class LottieEmptyList extends StatelessWidget {
  const LottieEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/empty_list.json',
          height: 250,
          width: 250,
        ),
        const Text(
          'Nenhum hábito para hoje, Adicione o Primeiro!',
          style:
              TextStyle(color: Temas.bluePrimary, fontWeight: FontWeight.w600),
          maxLines: 2,
        ),
      ],
    );
  }
}
