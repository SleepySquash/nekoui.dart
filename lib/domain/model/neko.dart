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
