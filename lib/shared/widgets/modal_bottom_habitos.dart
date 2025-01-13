import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:habitue_se/shared/temas.dart';

class ModalBottomHabitos extends StatelessWidget {
  const ModalBottomHabitos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _itemTile(
              icon: Icons.bookmark_add_outlined,
              title: 'Novo Habito',
              description:
                  'Ação repetitiva diária que contribui para seu crescimento pessoal.',
              onTap: () {
                context.push('/novo-habito');
                Navigator.pop(context);
              }),
          Gap(10),
          _itemTile(
              icon: Icons.add_task,
              title: 'Nova Tarefa',
              description:
                  'Ação especifica a ser concluída, visando cumprir um objetivo.',
              onTap: () {}),
        ],
      ),
    );
  }

  _itemTile(
      {required String title,
      String? description,
      void Function()? onTap,
      IconData? icon}) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: description != null
          ? Text(
              description,
              style: const TextStyle(
                fontSize: 13,
              ),
            )
          : null,
      onTap: onTap,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),
      leading: icon != null
          ? Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Temas.secondary.withOpacity(.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                icon,
                color: Temas.primary,
              ),
            )
          : null,
    );
  }
}
