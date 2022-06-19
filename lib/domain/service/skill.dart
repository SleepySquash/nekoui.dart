import '../disposable_service.dart';
import '/domain/model/skill.dart';
import '/domain/repository/skill.dart';
import '/util/obs/obs.dart';

/// Service responsible for [Skill]s state management.
class SkillService extends DisposableService {
  SkillService(this._skillRepository);

  final AbstractSkillRepository _skillRepository;

  RxObsMap<String, Skill> get skills => _skillRepository.skills;

  void add(List<String> skills, [int amount = 0]) =>
      _skillRepository.add(skills, amount);

  /// Removes the provided [skills] in the specified [count] from the [skills].
  ///
  /// Fully removes the [skills], if [count] is `null`.
  void remove(List<String> skills, [int? count]) =>
      _skillRepository.remove(skills, count);
}
