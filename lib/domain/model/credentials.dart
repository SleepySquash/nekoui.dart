import 'package:hive/hive.dart';

import '../model_type_id.dart';

part 'credentials.g.dart';

@HiveType(typeId: ModelTypeId.credentials)
class Credentials extends HiveObject {}
