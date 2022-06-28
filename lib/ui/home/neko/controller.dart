import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nekoui/domain/model/skill.dart';
import 'package:nekoui/router.dart';
import 'package:nekoui/ui/home/neko/collection/activity.dart';
import 'package:nekoui/ui/novel/novel.dart';
import 'package:nekoui/ui/widget/backdrop_button.dart';

import '/domain/model/neko.dart';
import '/domain/service/neko.dart';
import 'collection/topic.dart';

enum NekoViewScreen {
  action,
  activity,
  request,
  talk,
}

class NekoController extends GetxController {
  NekoController(this._nekoService, {this.withWardrobe = false});

  final bool withWardrobe;
  final Rx<NekoViewScreen?> screen = Rx(null);

  List<TalkTopic> topics = [];
  List<TalkTopic> activities = [];

  final NekoService _nekoService;
  StreamSubscription? _attentionSubscription;

  Rx<Neko?> get neko => _nekoService.neko;
  String? get name => neko.value?.name.value ?? 'Неко';

  @override
  void onInit() {
    _attentionSubscription = _nekoService.attention.listen((_) {});
    super.onInit();
  }

  @override
  void onClose() {
    _attentionSubscription?.cancel();
    super.onClose();
  }

  void open(NekoViewScreen screen) {
    this.screen.value = screen;

    switch (screen) {
      case NekoViewScreen.action:
      case NekoViewScreen.request:
        // No-op.
        break;

      case NekoViewScreen.activity:
        activities = ActivityExtension.activities(name).sample(7);
        break;

      case NekoViewScreen.talk:
        topics = TopicExtension.topics(name).sample(7);
        break;
    }
  }

  void talk({
    int amount = 5,
    int affinity = 0,
  }) {
    _nekoService.addSkill(
      [Skills.basic.name, BasicSkills.talking.name],
      amount,
    );

    _nekoService.necessity(social: 5);
    _nekoService.affinity(affinity);
  }
}

enum TopicType {
  chat,
  romantic,
  friendly,
  study,
  food,
  together,
}

class TalkTopic {
  TalkTopic(
    this.topic,
    this.lines, {
    this.type = TopicType.chat,
    this.affinity = 0,
    this.skill = 1,
    this.necessity = 5,
  });

  final String topic;
  final List<ScenarioLine> lines;
  final TopicType type;

  final int skill;
  final int affinity;
  final double necessity;

  Future<void> novel() async {
    await Novel.show(context: router.context!, scenario: [
      ObjectLine(BackdropRect(), wait: false),
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

  Widget build() {
    Icon icon;

    switch (type) {
      case TopicType.chat:
        icon = const Icon(Icons.chat_bubble_rounded, color: Colors.blue);
        break;

      case TopicType.romantic:
        icon = const Icon(Icons.favorite, color: Colors.red);
        break;

      case TopicType.friendly:
        icon = const Icon(Icons.favorite, color: Colors.green);
        break;

      case TopicType.study:
        icon = const Icon(Icons.school, color: Colors.blueGrey);
        break;

      case TopicType.food:
        icon = const Icon(Icons.fastfood, color: Colors.orange);
        break;

      case TopicType.together:
        icon = const Icon(Icons.people, color: Colors.pink);
        break;
    }

    return BackdropBubble(
      text: topic,
      icon: icon.icon,
      color: icon.color,
      onTap: novel,
    );
  }
}
