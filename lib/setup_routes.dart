import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/models/habito.dart';
import 'package:habitue_se/pages/adicionar_novo_habito/adicionar_novo_habido.dart';
import 'package:habitue_se/pages/desafios/desafios_page.dart';
import 'package:habitue_se/pages/habitos/habitos_page.dart';
import 'package:habitue_se/pages/home_page/pages/home_page.dart';
import 'package:habitue_se/pages/bottom_app_bar/bottom_app_bar_widget.dart';
import 'package:habitue_se/pages/tarefas/tarefas_page.dart';

class Routes {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final route = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/home',
      routes: [
        ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (context, state, child) {
              return BottomAppBarWidget(
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => HomePage(),
              ),
              GoRoute(
                path: '/desafios',
                builder: (BuildContext context, GoRouterState state) {
                  return DesafiosPage();
                },
              ),
              GoRoute(
                path: '/tarefas',
                builder: (BuildContext context, GoRouterState state) {
                  return TarefasPage();
                },
              ),
              GoRoute(
                path: '/habitos',
                builder: (BuildContext context, GoRouterState state) {
                  return HabitosPage();
                },
              ),
            ]),
        GoRoute(
            parentNavigatorKey: rootNavigatorKey,
            path: '/novo-habito',
            builder: (context, state) {
              final habitoParaEditar = state.extra;
              if (habitoParaEditar is! Habito) {
                return AdicionarNovoHabido();
              }
              return AdicionarNovoHabido(habitoParaEditar: habitoParaEditar);
            })
      ]);
}
