import 'package:flutter/widgets.dart' show TransformationController;
import 'package:get/get.dart';

import '/domain/model/neko.dart';
import '/domain/model/skill.dart';
import '/domain/service/neko.dart';
import '/util/obs/obs.dart';

class FlowchartController extends GetxController {
  FlowchartController(this._nekoService);

  final RxMap<String, SkillDescriptionEntry> descriptions = RxMap();
  final SkillDescriptionEntry initial = SkillDescriptionEntry();

  final NekoService _nekoService;

  Rx<Neko?> get neko => _nekoService.neko;
  RxObsMap<String, Skill> get skills => _nekoService.skills;
}

class SkillDescriptionEntry {
  final TransformationController transformation = TransformationController();
}
