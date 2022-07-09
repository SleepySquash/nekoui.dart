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
import 'package:hive/hive.dart';

import '../model_type_id.dart';

part 'necessities.g.dart';

/// Basic necessities (hunger, thirst, etc) represented as the numbers.
@HiveType(typeId: ModelTypeId.necessities)
class Necessities extends HiveObject {
  Necessities({
    RxDouble? hunger,
    this.maxHunger = 100,
    RxDouble? thirst,
    this.maxThirst = 100,
    RxDouble? naturalNeed,
    this.maxNaturalNeed = 100,
    RxDouble? cleanness,
    this.maxCleanness = 100,
    RxDouble? energy,
    this.maxEnergy = 100,
    RxDouble? social,
    this.maxSocial = 100,
  })  : hunger = hunger ?? RxDouble(50),
        thirst = thirst ?? RxDouble(50),
        naturalNeed = naturalNeed ?? RxDouble(50),
        cleanness = cleanness ?? RxDouble(50),
        energy = energy ?? RxDouble(50),
        social = social ?? RxDouble(50);

  /// Hunger component of these [Necessities].
  @HiveField(0)
  final RxDouble hunger;

  @HiveField(1)
  double maxHunger;

  /// Thirst component of these [Necessities].
  @HiveField(2)
  final RxDouble thirst;

  @HiveField(3)
  double maxThirst;

  /// Natural need component of these [Necessities].
  @HiveField(4)
  final RxDouble naturalNeed;

  @HiveField(5)
  double maxNaturalNeed;

  /// Cleanness component of these [Necessities].
  @HiveField(6)
  final RxDouble cleanness;

  @HiveField(7)
  double maxCleanness;

  /// Energy component of these [Necessities].
  @HiveField(8)
  final RxDouble energy;

  @HiveField(9)
  double maxEnergy;

  /// Social need component of these [Necessities].
  @HiveField(10)
  final RxDouble social;

  @HiveField(11)
  double maxSocial;

  /// List of all the [Necessities].
  List<RxDouble> get params => [hunger, thirst, cleanness, energy, social];

  /// Indicates whether these [Necessities] are considered satisfied.
  bool get areSatisfied => params.every((e) => e >= 20);

  /// Ensures all the [params] are clamped to its max and min values.
  void ensureConstraints() {
    if (hunger.value > maxHunger) hunger.value = maxHunger;
    if (hunger.value < 0) hunger.value = 0;
    if (thirst.value > maxThirst) thirst.value = maxThirst;
    if (thirst.value < 0) thirst.value = 0;
    if (naturalNeed.value > maxNaturalNeed) naturalNeed.value = maxNaturalNeed;
    if (naturalNeed.value < 0) naturalNeed.value = 0;
    if (cleanness.value > maxCleanness) cleanness.value = maxCleanness;
    if (cleanness.value < 0) cleanness.value = 0;
    if (energy.value > maxEnergy) energy.value = maxEnergy;
    if (energy.value < 0) energy.value = 0;
    if (social.value > maxSocial) social.value = maxSocial;
    if (social.value < 0) social.value = 0;
  }
}
