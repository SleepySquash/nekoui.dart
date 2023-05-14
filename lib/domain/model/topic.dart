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

import 'package:flutter/material.dart' show Icon, Icons, Colors;
import 'package:get/get.dart';
import 'package:novel/novel.dart';

import '/domain/model/skill.dart';
import '/domain/service/neko.dart';
import '/router.dart';

enum TopicType {
  casual, // discussions, small-talks, etc
  support, // supportive and warmth
  preference, // what is your favorite ...
  romance, // romantic talk
  profession, // professional, study or skill related
  interest, // about some specific interest
}

class TalkTopic {
  TalkTopic(
    this.topic,
    this.lines, {
    this.type = TopicType.casual,
    this.affinity = 0,
    this.skill = 1,
    this.necessity = 5,
  });

  final String topic;
  final List<Line> lines;
  final TopicType type;

  final int skill;
  final int affinity;
  final double necessity;

  Future<void> novel() async {
    await Novel.show(context: router.context!, scenario: [
      AddObjectLine(BackdropRect(), wait: false),
      CharacterLine.asset('person.png', duration: Duration.zero),
      ...lines,
    ]);

    NekoService nekoService = Get.find<NekoService>();

    nekoService.addSkill(
      [Skills.basic.name, BasicSkills.talking.name],
      skill,
    );

    nekoService.necessity(social: necessity);
    nekoService.affinity(affinity);
  }

  Icon get icon {
    switch (type) {
      case TopicType.casual:
        return const Icon(Icons.question_answer, color: Colors.blue);

      case TopicType.romance:
        return const Icon(Icons.favorite, color: Colors.red);

      case TopicType.support:
        return const Icon(Icons.favorite, color: Colors.green);

      case TopicType.profession:
        return const Icon(Icons.school, color: Colors.blueGrey);

      case TopicType.preference:
        return const Icon(Icons.help, color: Colors.orange);

      case TopicType.interest:
        return const Icon(Icons.people, color: Colors.pink);

      default:
        return const Icon(Icons.device_unknown);
    }
  }
}
