// Copyright © 2022 NIKITA ISAENKO, <https://github.com/SleepySquash>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

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
