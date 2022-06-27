import 'dart:async';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model/neko.dart';
import '/domain/repository/neko.dart';
import '/provider/hive/neko.dart';

class NekoRepository extends DisposableInterface
    implements AbstractNekoRepository {
  NekoRepository(
    this._nekoHive, {
    this.initial,
  });

  @override
  late final Rx<Neko> neko;

  final Neko? initial;

  final NekoHiveProvider _nekoHive;

  StreamSubscription<BoxEvent>? _localSubscription;

  HiveNeko get _local => _nekoHive.get() ?? HiveNeko(initial ?? Neko());

  @override
  void onInit() {
    HiveNeko? stored = _nekoHive.get();
    neko = Rx(stored?.neko ?? initial ?? Neko());
    if (stored == null) {
      _nekoHive.put(HiveNeko(neko.value));
    }

    _initLocalSubscription();

    DateTime? updatedAt = stored?.updatedAt;
    if (updatedAt != null) {
      Duration difference = DateTime.now().difference(updatedAt);
      necessity(
        hunger: -AbstractNekoRepository.hungerInSecond * difference.inSeconds,
        thirst: -AbstractNekoRepository.thirstInSecond * difference.inSeconds,
        social: -AbstractNekoRepository.socialInSecond * difference.inSeconds,
        toilet: -AbstractNekoRepository.toiletInLiter * difference.inSeconds,
        energy: -AbstractNekoRepository.energyInSecond * difference.inSeconds,
        cleanness: -AbstractNekoRepository.dirtyInSecond * difference.inSeconds,
      );
    }

    super.onInit();
  }

  @override
  void onClose() {
    _localSubscription?.cancel();
    super.onClose();
  }

  @override
  void eat(int value) {
    HiveNeko neko = _local;
    neko.neko.necessities.hunger.value += value;
    neko.neko.necessities.ensureConstraints();
    neko.updatedAt = DateTime.now();
    _nekoHive.put(neko);
  }

  @override
  void drink(int value) {
    HiveNeko neko = _local;
    neko.neko.necessities.thirst.value += value;
    neko.neko.necessities.ensureConstraints();
    neko.updatedAt = DateTime.now();
    _nekoHive.put(neko);
  }

  @override
  void necessity({
    double? hunger,
    double? thirst,
    double? toilet,
    double? cleanness,
    double? energy,
    double? social,
  }) {
    HiveNeko neko = _local;
    neko.neko.necessities.hunger.value += hunger ?? 0;
    neko.neko.necessities.thirst.value += thirst ?? 0;
    neko.neko.necessities.naturalNeed.value += toilet ?? 0;
    neko.neko.necessities.cleanness.value += cleanness ?? 0;
    neko.neko.necessities.energy.value += energy ?? 0;
    neko.neko.necessities.social.value += social ?? 0;
    neko.neko.necessities.ensureConstraints();
    neko.updatedAt = DateTime.now();
    _nekoHive.put(neko);
  }

  @override
  void affinity(int amount) {
    HiveNeko neko = _local;
    neko.neko.affinity.value += amount;
    neko.updatedAt = DateTime.now();
    _nekoHive.put(neko);
  }

  void _initLocalSubscription() {
    _localSubscription = _nekoHive.boxEvents.listen((e) {
      if (e.deleted) {
        throw UnsupportedError('Neko should never get deleted');
      } else {
        neko.value = e.value.neko;
        neko.refresh();
      }
    });
  }
}
