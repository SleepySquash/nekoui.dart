import 'dart:async';

import 'package:get/get.dart';

import '../disposable_service.dart';
import '/domain/model/item.dart';
import '/domain/model/neko.dart';
import '/domain/model/skill.dart';
import '/domain/model/thought.dart';
import '/domain/model/trait.dart';
import '/domain/repository/neko.dart';
import '/domain/repository/skill.dart';
import '/domain/repository/trait.dart';
import '/util/obs/obs.dart';

/// Service responsible for [Neko]'s state management.
class NekoService extends DisposableService {
  NekoService(
    this._nekoRepository,
    this._skillRepository,
    this._traitRepository,
  );

  final RxObsList<Thought> thoughts = RxObsList();

  final AbstractNekoRepository _nekoRepository;
  final AbstractSkillRepository _skillRepository;
  final AbstractTraitRepository _traitRepository;

  final StreamController<void> _attention = StreamController.broadcast();

  late final Timer _fixedStep;

  Rx<Neko> get neko => _nekoRepository.neko;
  RxObsMap<String, Skill> get skills => _skillRepository.skills;
  RxObsMap<Traits, Trait> get traits => _traitRepository.traits;

  Stream<void> get attention => _attention.stream;
  bool get hasAttention => _attention.hasListener;

  @override
  void onInit() {
    DateTime delta = DateTime.now();
    _fixedStep = Timer.periodic(1.seconds, (_) {
      Duration difference = DateTime.now().difference(delta);

      _nekoRepository.necessity(
        hunger: -AbstractNekoRepository.hungerInSecond *
            difference.inMilliseconds /
            1000,
        thirst: -AbstractNekoRepository.thirstInSecond *
            difference.inMilliseconds /
            1000,
        social: -AbstractNekoRepository.socialInSecond *
            difference.inMilliseconds /
            1000,
        toilet: -AbstractNekoRepository.toiletInLiter *
            difference.inMilliseconds /
            1000,
        energy: -AbstractNekoRepository.energyInSecond *
            difference.inMilliseconds /
            1000,
        cleanness: -AbstractNekoRepository.dirtyInSecond *
            difference.inMilliseconds /
            1000,
      );

      delta = DateTime.now();
    });

    super.onInit();
  }

  @override
  void onClose() {
    _fixedStep.cancel();
    super.onClose();
  }

  bool give(Item item) {
    if (item is Consumable) {
      bool consumed = consume(item);

      if (consumed) {
        if (item is Eatable) {
          addThought(Thought('Вкусняшка!'));
          addSkill([Skills.basic.name, BasicSkills.eating.name], 5);
          affinity(1);
        } else if (item is Drinkable) {
          addThought(Thought('Мм, водичка!'));
          addSkill([Skills.basic.name, BasicSkills.eating.name], 5);
          affinity(1);
        }
      } else {
        addThought(Thought('В меня не влазит >.<'));
      }

      return consumed;
    }

    addThought(Thought('А что с этим делать?..'));
    return false;
  }

  /// Consumes the provided [item], if possible, otherwise returns `false`.
  bool consume(Consumable item) {
    bool consumed = false;
    if (item is Eatable) {
      if (neko.value.necessities.hunger.value + item.hunger / 3 <=
          neko.value.necessities.maxHunger) {
        _nekoRepository.eat(item.hunger);
        consumed = true;
      }
    }

    if (item is Drinkable) {
      if (neko.value.necessities.thirst.value + item.thirst / 3 <=
          neko.value.necessities.maxThirst) {
        _nekoRepository.drink(item.thirst);
        consumed = true;
      }
    }

    return consumed;
  }

  void necessity({
    double? hunger,
    double? thirst,
    double? toilet,
    double? cleanness,
    double? energy,
    double? social,
  }) =>
      _nekoRepository.necessity(
        hunger: hunger,
        thirst: thirst,
        toilet: toilet,
        cleanness: cleanness,
        energy: energy,
        social: social,
      );

  void affinity(int amount) => _nekoRepository.affinity(amount);

  void addThought(Thought thought) {
    thoughts.add(thought
      ..timer = Timer.periodic(1.seconds, (t) {
        thought.left -= 1.seconds;
        if (thought.left.isNegative) {
          thoughts.remove(thought);
          t.cancel();
        }
      }));
  }

  /// Adds the provided [amount] to the specifed [skills].
  void addSkill(List<String> skills, [int amount = 0]) =>
      _skillRepository.add(skills, amount);

  /// Removes the provided [skills] in the specified [count] from the [skills].
  ///
  /// Fully removes the [skills], if [count] is `null`.
  void removeSkill(List<String> skills, [int? count]) =>
      _skillRepository.remove(skills, count);
}
