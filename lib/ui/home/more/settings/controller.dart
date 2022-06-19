import 'package:get/get.dart';

import '/domain/service/auth.dart';

class SettingsController extends GetxController {
  SettingsController(this._authService);
  final AuthService _authService;

  void reset() {
    _authService.logout();
  }
}
