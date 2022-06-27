import 'package:flutter/material.dart';
import 'package:nekoui/ui/novel/novel.dart';

import '/ui/widget/backdrop_button.dart';
import '../controller.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen(this.c, {Key? key}) : super(key: key);

  final NekoController c;

  @override
  Widget build(BuildContext context) {
    var activities = [
      BackdropBubble(
        text: 'Сходить в парк',
        icon: Icons.favorite,
        color: Colors.red,
        onTap: () async {
          await Novel.show(
            context: context,
            scenario: [
              BackgroundLine('park.jpg', wait: false),
              CharacterLine('person.png'),
              DialogueLine('Вау, тут так красиво!', by: c.name),
              DialogueLine('Спасибо, что сходил со мной!! :3', by: c.name),
            ],
          );

          c.talk(affinity: 2);
        },
      ),
    ];

    return Stack(
      key: const Key('ActivityScreen'),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(children: activities),
          ),
        ),
      ],
    );
  }
}
