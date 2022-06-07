import 'package:hive/hive.dart';

import '../model_type_id.dart';

part 'trait.g.dart';

@HiveType(typeId: ModelTypeId.trait)
class Trait {
  Trait(this.value);

  @HiveField(0)
  int value;
}

enum Traits {
  talkative,
  willingly,
  loyalty,
}
