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
    this.ei = 0,
    this.sn = 0,
    this.tf = 0,
    this.jp = 0,
  });

  /// Extroversion - Introversion.
  @HiveField(0)
  int ei;

  /// Sensing - Intuition.
  @HiveField(1)
  int sn;

  /// Thinking - Feeling.
  @HiveField(2)
  int tf;

  /// Judging - Perception.
  @HiveField(3)
  int jp;

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
