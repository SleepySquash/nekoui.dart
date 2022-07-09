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
      CharacterLine('person.png', duration: Duration.zero),
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
