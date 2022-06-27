import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model_type_id.dart';

part 'mood.g.dart';

@HiveType(typeId: ModelTypeId.mood)
class Mood {
  const Mood(this.pleasant, this.activation);

  @HiveField(0)
  final int max = 1000;

  @HiveField(1)
  final int pleasant;

  @HiveField(2)
  final int activation;

  MoodEnum get asEnum {
    if (activation.abs() < max / 20 && pleasant.abs() < max / 20) {
      return MoodEnum.calm;
    }

    int divided = (activation + max) ~/ (2 * max) * 8;
    switch (divided) {
      case 0:
        return pleasant < 0 ? MoodEnum.fatigued : MoodEnum.calm;

      case 1:
        return pleasant < 0 ? MoodEnum.bored : MoodEnum.relaxed;

      case 2:
        return pleasant < 0 ? MoodEnum.depressed : MoodEnum.serene;

      case 3:
        return pleasant < 0 ? MoodEnum.sad : MoodEnum.contented;

      case 4:
        return pleasant < 0 ? MoodEnum.upset : MoodEnum.happy;

      case 5:
        return pleasant < 0 ? MoodEnum.stressed : MoodEnum.elated;

      case 6:
        return pleasant < 0 ? MoodEnum.nervous : MoodEnum.excited;

      default:
        return pleasant < 0 ? MoodEnum.tense : MoodEnum.alert;
    }
  }
}

enum MoodEnum {
  alert,
  bored,
  calm,
  contented,
  depressed,
  elated,
  excited,
  fatigued,
  happy,
  nervous,
  neutral,
  relaxed,
  sad,
  scared,
  serene,
  stressed,
  tense,
  upset,
}
