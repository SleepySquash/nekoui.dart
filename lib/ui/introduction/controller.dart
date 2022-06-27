import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:get/get.dart';

import '/domain/model/neko.dart';
import '/domain/service/auth.dart';
import '/router.dart';
import '/ui/novel/novel.dart';

class IntroductionController extends GetxController {
  IntroductionController(this._authService);

  final RxBool naming = RxBool(false);
  final RxBool nameIsEmpty = RxBool(true);
  final TextEditingController name = TextEditingController();

  final AuthService _authService;

  Rx<RxStatus> get authStatus => _authService.status;

  @override
  void onReady() {
    _novel();
    super.onReady();
  }

  void accept() {
    if (name.text.isNotEmpty) {
      _register(name.text);
    }
  }

  Future<void> _register(String name) async {
    await _authService.register();
    router.home(neko: Neko(name: name));
  }

  Future<void> _novel() async {
    await Future.delayed(500.milliseconds);
    await Novel.show(
      context: router.context!,
      scenario: [
        BackgroundLine('park.jpg'),
        CharacterLine('person.png'),
        DialogueLine('Hello, I am Vanilla!', by: 'Vanilla'),
        DialogueLine('And you?', by: 'Vanilla'),
      ],
    );
    naming.value = true;
  }
}
