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
