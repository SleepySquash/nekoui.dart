import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model_type_id.dart';

part 'neko.g.dart';

/// Person representing a cat-girl.
@HiveType(typeId: ModelTypeId.neko)
class Neko extends HiveObject {
  Neko({
    String name = 'Vanilla',
  }) : name = RxString(name);

  @HiveField(0)
  final RxString name;
}
