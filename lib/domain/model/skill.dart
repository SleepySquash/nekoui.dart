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
  /// [BasicSkills].
  basic,

  /// [DrawingSkills].
  drawing,

  /// [CookingSkills].
  cooking,

  sewing,
  cosplaying,
  crafting,
  programming,
  sports,
  perception,
  choreography,
  music,

  /// [ScienceSkills].
  science,

  photography,
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
