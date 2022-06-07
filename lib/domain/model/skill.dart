import 'package:hive_flutter/hive_flutter.dart';

import '../model_type_id.dart';

part 'skill.g.dart';

/// Ability to do something.
@HiveType(typeId: ModelTypeId.skill)
class Skill {
  Skill(
    this.value, {
    this.skills,
  });

  @HiveField(0)
  int value;

  @HiveField(1)
  Map<String, Skill>? skills;
}

/// Available [Skill]s list.
enum Skills {
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
