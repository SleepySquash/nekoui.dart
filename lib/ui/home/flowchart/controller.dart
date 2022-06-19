import 'package:flutter/widgets.dart' show TransformationController;
import 'package:get/get.dart';

import '/domain/model/neko.dart';
import '/domain/model/skill.dart';
import '/domain/service/neko.dart';
import '/domain/service/skill.dart';
import '/util/obs/obs.dart';

class FlowchartController extends GetxController {
  FlowchartController(this._nekoService, this._skillService);

  final RxMap<String, SkillDescriptionEntry> descriptions = RxMap();
  final SkillDescriptionEntry initial = SkillDescriptionEntry();

  final NekoService _nekoService;
  final SkillService _skillService;

  Rx<Neko?> get neko => _nekoService.neko;
  RxObsMap<String, Skill> get skills => _skillService.skills;
}

class SkillDescriptionEntry {
  final TransformationController transformation = TransformationController();
}
