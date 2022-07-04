import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller.dart';
import '/domain/model/skill.dart';
import '/domain/service/neko.dart';
import '/ui/widget/backdrop_button.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen(this.c, {Key? key}) : super(key: key);

  final NekoController c;

  @override
  Widget build(BuildContext context) {
    var requests = [
      BackdropBubble(
        text: 'Попросить нарисовать...',
        icon: const Icon(Icons.favorite, color: Colors.red),
        color: Colors.red,
        onTap: () {
          Get.find<NekoService>().addSkill(
            [Skills.drawing.name, DrawingSkills.anatomy.name],
            10,
          );
        },
      ),
    ];

    return Stack(
      key: const Key('RequestScreen'),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(children: requests),
          ),
        ),
      ],
    );
  }
}
