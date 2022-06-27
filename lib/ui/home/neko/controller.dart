import 'dart:async';

import 'package:get/get.dart';
import 'package:nekoui/domain/model/skill.dart';

import '/domain/model/neko.dart';
import '/domain/service/neko.dart';

enum NekoViewScreen {
  action,
  activity,
  request,
  talk,
}

class NekoController extends GetxController {
  NekoController(this._nekoService, {this.withWardrobe = false});

  final bool withWardrobe;
  final Rx<NekoViewScreen?> screen = Rx(null);

  final NekoService _nekoService;
  StreamSubscription? _attentionSubscription;

  Rx<Neko?> get neko => _nekoService.neko;
  String? get name => neko.value?.name.value ?? 'Неко';

  @override
  void onInit() {
    _attentionSubscription = _nekoService.attention.listen((_) {});
    super.onInit();
  }

  @override
  void onClose() {
    _attentionSubscription?.cancel();
    super.onClose();
  }

  void talk({
    int amount = 5,
    int affinity = 0,
  }) {
    _nekoService.addSkill(
      [Skills.basic.name, BasicSkills.talking.name],
      amount,
    );

    _nekoService.necessity(social: 5);
    _nekoService.affinity(affinity);
  }
}
