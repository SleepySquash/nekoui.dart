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

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/util/obs/obs.dart';

/// Ability to do something.
class Skill extends HiveObject {
  Skill(
    this.name, {
    int value = 0,
    Map<String, Skill>? skills,
  })  : value = RxInt(value),
        skills = skills == null ? null : RxObsMap(skills);

  @HiveField(0)
  String name;

  @HiveField(1)
  RxInt value;

  @HiveField(2)
  RxObsMap<String, Skill>? skills;

  static MapEntry<String, Skill> entry(
    String name, {
    int value = 0,
    Map<String, Skill>? skills,
  }) =>
      MapEntry(name, Skill(name, value: value, skills: skills));

  double get progress {
    double points = value.value.toDouble();
    for (var s in skills?.values ?? const Iterable<Skill>.empty()) {
      points += s.value.value / 2;
    }

    return (points - level * 100) / 100;
  }

  int get level {
    double points = value.value.toDouble();
    for (var s in skills?.values ?? const Iterable<Skill>.empty()) {
      points += s.value.value / 2;
    }

    return points ~/ 100;
  }
}

/// Available [Skill]s list.
enum Skills {
  basic, // [BasicSkills].
  choreography,
  cooking, // [CookingSkills].
  cosplaying,
  crafting,
  drawing, // [DrawingSkills].
  music,
  perception,
  photography,
  programming,
  science, // [ScienceSkills].
  sewing,
  sports,
}

/// [Skills.basic] skills subset.
enum BasicSkills {
  eating,
  naturalNeed,
  showering,
  sleeping,
  talking,
}

/// [Skills.drawing] skills subset.
enum DrawingSkills {
  geometry,
  anatomy,
  shading,
  portrait,
  landscape,
  animations,
}

/// [Skills.cooking] skills subset.
enum CookingSkills {
  baking,
  drinks,
  salads,
  soups,
  sweets,
}

/// [Skills.science] skills subset.
enum ScienceSkills {
  math,
  biology,

  /// [SciencePhysicsSkills].
  physics,
}

/// [ScienceSkills.physics] skills subset.
enum SciencePhysicsSkills {
  quantum,
  mechanics,
  electricity,
}
