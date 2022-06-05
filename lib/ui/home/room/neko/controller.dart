import 'package:get/get.dart';

enum NekoViewScreen {
  ask,
  talk,
  action,
  activity,
}

class NekoController extends GetxController {
  final Rx<NekoViewScreen?> screen = Rx(null);
}
