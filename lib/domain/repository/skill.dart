import '/domain/model/skill.dart';
import '/util/obs/obs.dart';

abstract class AbstractSkillRepository {
  RxObsMap<String, Skill> get skills;
  void add(List<String> skills, [int amount]);
  void remove(List<String> skills, [int? amount]);
}
