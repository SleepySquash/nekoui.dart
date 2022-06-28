import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/util/obs/obs.dart';

/// Ability to do something.
class Interest extends HiveObject {
  Interest(
    this.name, {
    int value = 0,
    Map<String, Interest>? interests,
  })  : value = RxInt(value),
        interests = interests == null ? null : RxObsMap(interests);

  @HiveField(0)
  String name;

  @HiveField(1)
  RxInt value;

  @HiveField(2)
  RxObsMap<String, Interest>? interests;

  static MapEntry<String, Interest> entry(
    String name, {
    int value = 0,
    Map<String, Interest>? interests,
  }) =>
      MapEntry(name, Interest(name, value: value, interests: interests));

  double get progress {
    double points = value.value.toDouble();
    for (var s in interests?.values ?? const Iterable<Interest>.empty()) {
      points += s.value.value / 2;
    }

    return (points - level * 100) / 100;
  }

  int get level {
    double points = value.value.toDouble();
    for (var s in interests?.values ?? const Iterable<Interest>.empty()) {
      points += s.value.value / 2;
    }

    return points ~/ 100;
  }
}

/// Available [Interest]s list.
enum Interests {
  animals,
  anime,
  choreography,
  cooking,
  cosplaying,
  crafting,
  drawing,
  history,
  internet,
  movies,
  music,
  photography,
  programming,
  reading,
  science, // [ScienceInterest].
  sewing,
  technology,
  theather,
  games,
  mythology,
}

enum ScienceInterest {
  biology,
  chemistry,
  physics,
  astronomy,
  math,
  astrology,
}
