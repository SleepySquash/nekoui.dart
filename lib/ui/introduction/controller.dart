import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:get/get.dart';
import 'package:novel/novel.dart';
import 'package:rive/rive.dart';

import '/domain/model/neko.dart';
import '/domain/service/auth.dart';
import '/router.dart';

enum IntroductionStage {
  novel,
  character,
  name,
}

class IntroductionController extends GetxController {
  IntroductionController(this._authService);

  final Rx<IntroductionStage> stage = Rx(IntroductionStage.novel);

  final RxBool nameIsEmpty = RxBool(true);
  final TextEditingController name = TextEditingController();

  late final RiveAnimationController animation;

  final AuthService _authService;

  Rx<RxStatus> get authStatus => _authService.status;

  @override
  void onInit() {
    animation = SimpleAnimation('Idle1');
    super.onInit();
  }

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

    stage.value = IntroductionStage.character;
  }
}
