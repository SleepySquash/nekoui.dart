import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model_type_id.dart';

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
  })  : name = name ?? RxString('Vanilla'),
        age = age ?? RxInt(4),
        height = height ?? RxInt(60),
        weight = weight ?? RxInt(10),
        necessities = necessities ?? Necessities(),
        affinity = affinity ?? RxInt(0) {
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

  /// Reactive [Mood] of this [Neko].
  late final Rx<Mood> mood;
}

/// Basic necessities (hunger, thirst, etc) represented as the numbers.
@HiveType(typeId: ModelTypeId.necessities)
class Necessities extends HiveObject {
  Necessities({
    RxInt? hunger,
    this.maxHunger = 100,
    RxInt? thirst,
    this.maxThirst = 100,
    RxInt? cleanness,
    this.maxCleanness = 100,
    RxInt? energy,
    this.maxEnergy = 100,
    RxInt? social,
    this.maxSocial = 100,
  })  : hunger = hunger ?? RxInt(0),
        thirst = thirst ?? RxInt(0),
        cleanness = cleanness ?? RxInt(0),
        energy = energy ?? RxInt(0),
        social = social ?? RxInt(0);

  /// Hunger component of these [Necessities].
  @HiveField(0)
  final RxInt hunger;

  @HiveField(1)
  int maxHunger;

  /// Thirst component of these [Necessities].
  @HiveField(2)
  final RxInt thirst;

  @HiveField(3)
  int maxThirst;

  /// Cleanness component of these [Necessities].
  @HiveField(4)
  final RxInt cleanness;

  @HiveField(5)
  int maxCleanness;

  /// Energy component of these [Necessities].
  @HiveField(6)
  final RxInt energy;

  @HiveField(7)
  int maxEnergy;

  /// Social need component of these [Necessities].
  @HiveField(8)
  final RxInt social;

  @HiveField(9)
  int maxSocial;

  /// List of all the [Necessities].
  List<RxInt> get params => [hunger, thirst, cleanness, energy, social];

  /// Indicates whether these [Necessities] are considered satisfied.
  bool get areSatisfied => params.every((e) => e >= 20);

  /// Ensures all the [params] are clamped to its max and min values.
  void ensureConstraints() {
    if (hunger.value > maxHunger) hunger.value = maxHunger;
    if (hunger.value < 0) hunger.value = 0;
    if (thirst.value > maxThirst) thirst.value = maxThirst;
    if (thirst.value < 0) thirst.value = 0;
    if (cleanness.value > maxCleanness) cleanness.value = maxCleanness;
    if (cleanness.value < 0) cleanness.value = 0;
    if (energy.value > maxEnergy) energy.value = maxEnergy;
    if (energy.value < 0) energy.value = 0;
    if (social.value > maxSocial) social.value = maxSocial;
    if (social.value < 0) social.value = 0;
  }
}

enum Mood {
  exhausted,
  happy,
  horny,
  irritated,
  neutral,
  sad,
  scared,
}
