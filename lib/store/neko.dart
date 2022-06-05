import 'dart:async';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model/neko.dart';
import '/domain/repository/neko.dart';
import '/provider/hive/neko.dart';

class NekoRepository extends DisposableInterface
    implements AbstractNekoRepository {
  NekoRepository(this._nekoHive);

  @override
  final Rx<Neko?> neko = Rx<Neko?>(null);

  final NekoHiveProvider _nekoHive;

  StreamSubscription<BoxEvent>? _localSubscription;

  @override
  void onInit() {
    neko.value = _nekoHive.get();

    _initLocalSubscription();

    if (neko.value == null) {
      _nekoHive.put(Neko());
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
    neko.value?.necessities.hunger.value += value;
    neko.value?.necessities.ensureConstraints();
    _nekoHive.put(neko.value ?? Neko());
  }

  @override
  void drink(int value) {
    neko.value?.necessities.thirst.value += value;
    neko.value?.necessities.ensureConstraints();
    _nekoHive.put(neko.value ?? Neko());
  }

  void _initLocalSubscription() {
    _localSubscription = _nekoHive.boxEvents.listen((e) {
      if (e.deleted) {
        neko.value = null;
      } else {
        neko.value = e.value;
      }
    });
  }
}
