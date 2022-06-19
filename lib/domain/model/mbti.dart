import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model_type_id.dart';

part 'mbti.g.dart';

enum Temperament {
  sanguine,
  choleric,
  melancholic,
  phlegmatic,
}

/// Myers–Briggs Type Indicator.
@HiveType(typeId: ModelTypeId.mbti)
class MBTI {
  MBTI({
    RxInt? ei,
    RxInt? sn,
    RxInt? tf,
    RxInt? jp,
  })  : ei = ei ?? 0.obs,
        sn = sn ?? 0.obs,
        tf = tf ?? 0.obs,
        jp = jp ?? 0.obs;

  /// Extroversion - Introversion.
  @HiveField(0)
  RxInt ei;

  /// Sensing - Intuition.
  @HiveField(1)
  RxInt sn;

  /// Thinking - Feeling.
  @HiveField(2)
  RxInt tf;

  /// Judging - Perception.
  @HiveField(3)
  RxInt jp;

  /// Returns [Temperament] approximation of this [MBTI].
  Temperament get temperament {
    switch (toString()) {
      case 'ESFP':
      case 'ENFJ':
      case 'ESFJ':
      case 'ESTP':
        return Temperament.sanguine;

      case 'ENFP':
      case 'ENTJ':
      case 'ESTJ':
      case 'ENTP':
        return Temperament.choleric;

      case 'ISFP':
      case 'INFJ':
      case 'ISFJ':
      case 'ISTP':
        return Temperament.phlegmatic;

      case 'INFP':
      case 'INTJ':
      case 'ISTJ':
      case 'INTP':
        return Temperament.melancholic;

      default:
        return Temperament.choleric;
    }
  }

  @override
  String toString() =>
      '${ei >= 0 ? 'E' : 'I'}${sn >= 0 ? 'S' : 'N'}${tf >= 0 ? 'T' : 'F'}${jp >= 0 ? 'J' : 'P'}';
}
