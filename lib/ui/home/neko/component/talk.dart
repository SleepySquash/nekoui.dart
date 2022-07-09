// Copyright © 2022 NIKITA ISAENKO, <https://github.com/SleepySquash>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../collection/topic.dart';
import '../controller.dart';
import '/domain/model/topic.dart';
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
