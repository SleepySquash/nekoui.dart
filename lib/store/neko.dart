import 'package:get/get.dart';

import '/domain/model/neko.dart';
import '/domain/repository/neko.dart';

class NekoRepository implements AbstractNekoRepository {
  @override
  final Rx<Neko?> neko = Rx<Neko?>(null);
}
