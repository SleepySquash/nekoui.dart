import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model_type_id.dart';
import 'mbti.dart';
import 'mood.dart';
import 'necessities.dart';

/// Person representing a cat-girl.
@HiveType(typeId: ModelTypeId.neko)
class Neko extends HiveObject {
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
  final MBTI mbti;

  /// Reactive [Mood] of this [Neko].
  final Rx<Mood> mood;
}
