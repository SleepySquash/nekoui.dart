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

import '../controller.dart';
import '/ui/widget/backdrop_button.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen(this.c, {Key? key}) : super(key: key);

  final NekoController c;

  @override
  Widget build(BuildContext context) {
    List<Widget> bubbles = c.activities
        .map(
          (e) => BackdropBubble(
            text: e.topic,
            icon: e.icon,
            color: e.icon.color,
            onTap: e.novel,
          ),
        )
        .toList();

    bool left = true;
    List<Widget> rows = [];
    for (int i = 0; i < bubbles.length; ++i) {
      var e = bubbles[i];
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
      key: const Key('ActivityScreen'),
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
      ],
    );
  }
}
