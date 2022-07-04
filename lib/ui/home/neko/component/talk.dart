import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nekoui/domain/model/topic.dart';
import 'package:nekoui/ui/home/neko/collection/topic.dart';

import '../controller.dart';
import '/ui/widget/backdrop_button.dart';

class TalkScreen extends StatelessWidget {
  const TalkScreen(this.c, {Key? key}) : super(key: key);

  final NekoController c;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Widget> bubbles;

      if (c.topic.value == null) {
        bubbles = TopicType.values.map(
          (e) {
            return BackdropBubble(
              text: e.name,
              icon: TalkTopic('', [], type: e).icon,
              color: TalkTopic('', [], type: e).icon.color,
              onTap: () => c.topic.value = e,
            );
          },
        ).toList();
      } else {
        bubbles = TopicExtension.topics(c.name)
            .where((e) => e.type == c.topic.value)
            .map(
              (e) => BackdropBubble(
                text: e.topic,
                icon: e.icon,
                color: e.icon.color,
                onTap: e.novel,
              ),
            )
            .toList();
      }

      bool left = true;
      List<Widget> rows = [];
      for (int i = 0; i < bubbles.length; ++i) {
        var e = bubbles[i];
        rows.add(
          Align(
            alignment: left ? Alignment.centerLeft : Alignment.centerRight,
            child: e,
          ),
        );

        left = !left;
      }

      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: rows
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(child: e),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}
