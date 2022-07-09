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

import 'mbti.dart';
import 'mood.dart';
import 'necessities.dart';

/// Person representing a cat-girl.
class Neko {
  Neko({
    String? name,
    int? age,
    int? height,
    int? weight,
    Necessities? necessities,
    int? affinity,
    MBTI? mbti,
    Mood mood = const Mood(0, 0),
  })  : name = RxString(name ?? 'Vanilla'),
        age = RxInt(age ?? 3),
        height = RxInt(height ?? 60),
        weight = RxInt(weight ?? 10),
        necessities = necessities ?? Necessities(),
        affinity = RxInt(affinity ?? 0),
        mbti = mbti ?? MBTI(),
        mood = Rx(mood);

  /// Name given the this [Neko].
  final RxString name;

  /// Age of this [Neko].
  final RxInt age;

  /// Height of this [Neko].
  final RxInt height;

  /// Weight of this [Neko].
  final RxInt weight;

  /// Basic [Necessities] this [Neko] has.
  final Necessities necessities;

  /// Numeric representation of the affinity this [Neko] feels towards you.
  final RxInt affinity;

  /// `Myers–Briggs Type Indicator` (MBTI) of this [Neko].
  final MBTI mbti;

  /// Reactive [Mood] of this [Neko].
  final Rx<Mood> mood;
}
