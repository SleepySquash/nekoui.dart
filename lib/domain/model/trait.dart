import 'package:hive/hive.dart';

import '../model_type_id.dart';

part 'trait.g.dart';

@HiveType(typeId: ModelTypeId.trait)
class Trait extends HiveObject {
  Trait(this.trait, this.value);

  @HiveField(0)
  int value;

  @HiveField(1)
  int trait;
}

enum Traits {
  talkative,
  willingly,
  loyalty,
}
