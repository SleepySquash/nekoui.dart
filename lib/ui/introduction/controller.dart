import 'package:get/get.dart';

import '/domain/service/auth.dart';
import '/router.dart';
import '/ui/novel/novel.dart';

class IntroductionController extends GetxController {
  IntroductionController(this._authService, {this.onBegin});

  final void Function()? onBegin;
  final AuthService _authService;

  Rx<RxStatus> get authStatus => _authService.status;

  @override
  void onReady() {
    _novel();
    super.onReady();
  }

  Future<void> _register() async {
    await _authService.register();
    router.home();
  }

  Future<void> _novel() async {
    await Future.delayed(500.milliseconds);
    await Novel.show(
      context: router.context!,
      scenario: Scenario(
        [
          ScenarioAddLine(
            Background('park.jpg'),
            wait: false,
          ),
          ScenarioAddLine(Character('person.png')),
          ScenarioAddLine(Dialogue(
            by: 'Vanilla',
            text: 'Hello, I am Vanilla!',
          )),
          ScenarioAddLine(Dialogue(
            by: 'Vanilla',
            text: 'And you?',
          )),
        ],
      ),
    );

    _register();
  }
}
