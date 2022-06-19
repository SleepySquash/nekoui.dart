import 'dart:async';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model/skill.dart';
import '/domain/repository/skill.dart';
import '/provider/hive/skill.dart';
import '/util/obs/obs.dart';

class SkillRepository extends DisposableInterface
    implements AbstractSkillRepository {
  SkillRepository(this._skillHive);

  @override
  late final RxObsMap<String, Skill> skills;

  final SkillHiveProvider _skillHive;

  StreamIterator<BoxEvent>? _localSubscription;

  @override
  void onInit() {
    skills = RxObsMap(
      Map.fromEntries(_skillHive.skills.map((e) => MapEntry(e.name, e))),
    );

    _initLocalSubscription();

    if (_skillHive.isEmpty) {
      _skillHive.put(
        Skill(
          Skills.basic.name,
          skills: Map.fromEntries(
            [
              Skill.entry(BasicSkills.eating.name),
              Skill.entry(BasicSkills.naturalNeed.name),
              Skill.entry(BasicSkills.showering.name),
              Skill.entry(BasicSkills.sleeping.name),
              Skill.entry(BasicSkills.talking.name),
            ],
          ),
        ),
      );
    }

    super.onInit();
  }

  @override
  void onClose() {
    _localSubscription?.cancel();
    super.onClose();
  }

  @override
  void add(List<String> skills, [int amount = 1]) {
    Skill? existing = _skillHive.get(skills.first);
    existing ??= Skill(skills.first);

    Skill? current = existing;
    for (int i = 1; i < skills.length; ++i) {
      String name = skills[i];
      current?.skills ??= RxObsMap.fromEntries([Skill.entry(name)]);

      if (current?.skills?[name] == null) {
        current?.skills?[name] = Skill(name);
      }

      current = current?.skills?[name];
    }

    current?.value += amount;
    _skillHive.put(existing);
  }

  @override
  void remove(List<String> skills, [int? amount]) {}

  Future<void> _initLocalSubscription() async {
    _localSubscription = StreamIterator(_skillHive.boxEvents);
    while (await _localSubscription!.moveNext()) {
      BoxEvent e = _localSubscription!.current;
      if (e.deleted) {
        skills.remove(e.key);
      } else {
        skills[e.key] = e.value;
      }
    }
  }
}
