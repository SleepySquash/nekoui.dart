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
