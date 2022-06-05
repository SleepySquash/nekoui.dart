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
    RxInt? thirst,
    RxInt? cleanness,
    RxInt? sleep,
    RxInt? social,
  })  : hunger = hunger ?? RxInt(0),
        thirst = thirst ?? RxInt(0),
        cleanness = cleanness ?? RxInt(0),
        sleep = sleep ?? RxInt(0),
        social = social ?? RxInt(0);

  /// Hunger component of these [Necessities].
  @HiveField(0)
  final RxInt hunger;

  /// Thirst component of these [Necessities].
  @HiveField(1)
  final RxInt thirst;

  /// Cleanness component of these [Necessities].
  @HiveField(2)
  final RxInt cleanness;

  /// Sleep component of these [Necessities].
  @HiveField(3)
  final RxInt sleep;

  /// Social need component of these [Necessities].
  @HiveField(4)
  final RxInt social;

  /// List of all the [Necessities].
  List<RxInt> get params => [hunger, thirst, cleanness, sleep, social];

  /// Indicates whether these [Necessities] are considered satisfied.
  bool get areSatisfied => params.every((e) => e >= 20);
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
