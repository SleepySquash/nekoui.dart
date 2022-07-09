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
