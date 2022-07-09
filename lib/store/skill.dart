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
