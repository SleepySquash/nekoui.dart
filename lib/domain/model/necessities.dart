import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model_type_id.dart';

part 'necessities.g.dart';

/// Basic necessities (hunger, thirst, etc) represented as the numbers.
@HiveType(typeId: ModelTypeId.necessities)
class Necessities extends HiveObject {
  Necessities({
    RxInt? hunger,
    this.maxHunger = 100,
    RxInt? thirst,
    this.maxThirst = 100,
    RxInt? naturalNeed,
    this.maxNaturalNeed = 100,
    RxInt? cleanness,
    this.maxCleanness = 100,
    RxInt? energy,
    this.maxEnergy = 100,
    RxInt? social,
    this.maxSocial = 100,
  })  : hunger = hunger ?? RxInt(0),
        thirst = thirst ?? RxInt(0),
        naturalNeed = naturalNeed ?? RxInt(0),
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

  /// Natural need component of these [Necessities].
  @HiveField(4)
  final RxInt naturalNeed;

  @HiveField(5)
  int maxNaturalNeed;

  /// Cleanness component of these [Necessities].
  @HiveField(6)
  final RxInt cleanness;

  @HiveField(7)
  int maxCleanness;

  /// Energy component of these [Necessities].
  @HiveField(8)
  final RxInt energy;

  @HiveField(9)
  int maxEnergy;

  /// Social need component of these [Necessities].
  @HiveField(10)
  final RxInt social;

  @HiveField(11)
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
