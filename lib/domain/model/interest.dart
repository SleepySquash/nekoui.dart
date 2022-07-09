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
