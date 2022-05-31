import 'package:get/get.dart';

import '/router.dart';
import '/domain/service/auth.dart';

class AuthController extends GetxController {
  AuthController(this._authService);

  final AuthService _authService;

  Rx<RxStatus> get authStatus => _authService.status;

  Future<void> signIn() async {
    await _authService.signIn();
    router.home();
  }

  Future<void> register() async {
    await _authService.register();
    router.home();
  }
}
