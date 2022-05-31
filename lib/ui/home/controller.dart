import 'package:get/get.dart';

import '/router.dart';
import '/domain/service/auth.dart';

class HomeController extends GetxController {
  HomeController(this._auth);

  /// Authentication service to determine auth status.
  final AuthService _auth;

  /// Returns user authentication status.
  Rx<RxStatus> get auth => _auth.status;

  Future<void> logout() async {
    await _auth.logout();
    router.auth();
  }
}
