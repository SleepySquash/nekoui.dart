import 'package:get/get.dart';

import '/domain/model/neko.dart';

abstract class AbstractNekoRepository {
  Rx<Neko?> get neko;
}
