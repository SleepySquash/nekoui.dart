import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:nekoui/domain/model/skill.dart';

import '../model_type_id.dart';
import 'mbti.dart';
import 'mood.dart';
import 'necessities.dart';
import 'trait.dart';

part 'neko.g.dart';

/// Person representing a cat-girl.
@HiveType(typeId: ModelTypeId.neko)
class Neko extends HiveObject {
  Neko({
    RxString? name,
    RxInt? age,
    RxInt? height,
    RxInt? weight,
    Necessities? necessities,
    RxInt? affinity,
    Rx<MBTI>? mbti,
    Map<String, Skill>? skills,
    Map<String, Trait>? traits,
  })  : name = name ?? RxString('Vanilla'),
        age = age ?? 3.obs,
        height = height ?? 60.obs,
        weight = weight ?? 10.obs,
        necessities = necessities ?? Necessities(),
        affinity = affinity ?? 0.obs,
        mbti = mbti ?? MBTI().obs,
        skills = RxMap(skills ?? {}),
        traits = RxMap(traits ?? {}) {
    if (this.necessities.areSatisfied) {
      mood = Rx(Mood.neutral);
    } else {
      mood = Rx(Mood.exhausted);
    }
  }

  /// Name given the this [Neko].
  @HiveField(0)
  final RxString name;

  /// Age of this [Neko].
  @HiveField(1)
  final RxInt age;

  /// Height of this [Neko].
  @HiveField(2)
  final RxInt height;

  /// Weight of this [Neko].
  @HiveField(3)
  final RxInt weight;

  /// Basic [Necessities] this [Neko] has.
  @HiveField(4)
  final Necessities necessities;

  /// Numeric representation of the affinity this [Neko] feels towards you.
  @HiveField(5)
  final RxInt affinity;

  /// `Myers–Briggs Type Indicator` (MBTI) of this [Neko].
  @HiveField(6)
  final Rx<MBTI> mbti;

  @HiveField(7)
  final RxMap<String, Trait> traits;

  @HiveField(8)
  final RxMap<String, Skill> skills;

  /// Reactive [Mood] of this [Neko].
  late final Rx<Mood> mood;
}
