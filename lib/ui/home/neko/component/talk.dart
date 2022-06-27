import 'package:flutter/material.dart';
import 'package:nekoui/ui/novel/novel.dart';
import 'package:nekoui/ui/widget/backdrop_button.dart';

import '../controller.dart';

class TalkScreen extends StatelessWidget {
  const TalkScreen(this.c, {Key? key}) : super(key: key);

  final NekoController c;

  @override
  Widget build(BuildContext context) {
    var topics = [
      BackdropBubble(
        text: 'Мне нравится твоя улыбка',
        icon: Icons.favorite,
        color: Colors.red,
        onTap: () async {
          await Novel.show(
            context: context,
            scenario: [
              ObjectLine(BackdropRect(), wait: false),
              CharacterLine('person.png', duration: Duration.zero),
              DialogueLine('Ух ты!', by: c.name),
            ],
          );

          c.talk(affinity: 1);
        },
      ),
      BackdropBubble(
        text: 'Как дела с учёбой?',
        icon: Icons.school,
        color: Colors.blueGrey,
        onTap: () async {
          await Novel.show(
            context: context,
            scenario: [
              ObjectLine(BackdropRect(), wait: false),
              CharacterLine('person.png', duration: Duration.zero),
              DialogueLine('Памаги...', by: c.name),
            ],
          );

          c.talk(affinity: 1);
        },
      ),
      const BackdropBubble(
        text: 'Проголодалась?',
        icon: Icons.fastfood,
        color: Colors.orange,
      ),
      const BackdropBubble(
        text: 'Хочешь чем-нибудь заняться?',
        icon: Icons.people,
        color: Colors.pink,
      ),
      const BackdropBubble(
        text: 'Как тебе "Тортик"?',
        icon: Icons.fastfood,
        color: Colors.orange,
      ),
      BackdropBubble(
        text: 'Про теорему Пифагора',
        icon: Icons.school,
        color: Colors.blueGrey,
        onTap: () async {
          await Novel.show(
            context: context,
            scenario: [
              ObjectLine(BackdropRect(), wait: false),
              CharacterLine('person.png', duration: Duration.zero),
              DialogueLine(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi cursus velit magna.',
                by: c.name,
              ),
            ],
          );

          c.talk(affinity: 1);
        },
      ),
      const BackdropBubble(
        text: 'Как ты любишь проводить время?',
        icon: Icons.chat,
        color: Colors.blue,
      ),
    ];

    bool left = true;

    List<Widget> rows = [];

    for (int i = 0; i < topics.length; ++i) {
      var e = topics[i];
      rows.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (left) const Spacer(flex: 10),
            Flexible(flex: 10, child: e),
            if (!left) const Spacer(flex: 10),
          ],
        ),
      );

      left = !left;
    }

    return Stack(
      key: const Key('TalkScreen'),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rows
                  .map((e) => Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: e,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BackdropIconButton(
              icon: Icons.chat,
              color: Colors.blue.withOpacity(0.4),
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
