import 'dart:async';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model/trait.dart';
import '/domain/repository/trait.dart';
import '/provider/hive/trait.dart';
import '/util/obs/obs.dart';

class TraitRepository extends DisposableInterface
    implements AbstractTraitRepository {
  TraitRepository(this._traitHive);

  @override
  late final RxObsMap<Traits, Trait> traits;

  final TraitHiveProvider _traitHive;

  StreamIterator<BoxEvent>? _localSubscription;

  @override
  void onInit() {
    traits = RxObsMap(Map.fromEntries(
      _traitHive.traits.map((e) => MapEntry(Traits.values[e.trait], e)),
    ));

    _initLocalSubscription();

    super.onInit();
  }

  @override
  void onClose() {
    _localSubscription?.cancel();
    super.onClose();
  }

  @override
  void add(Traits trait, [int amount = 1]) {}

  @override
  void remove(Traits trait, [int? amount]) {}

  Future<void> _initLocalSubscription() async {
    _localSubscription = StreamIterator(_traitHive.boxEvents);
    while (await _localSubscription!.moveNext()) {
      BoxEvent e = _localSubscription!.current;
      if (e.deleted) {
        traits.remove(e.key);
      } else {
        traits[Traits.values[e.key]] = e.value;
      }
    }
  }
}
