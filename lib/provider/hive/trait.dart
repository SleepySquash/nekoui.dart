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

import 'package:hive_flutter/hive_flutter.dart';

import '/domain/model/trait.dart';
import 'base.dart';

/// [Hive] storage for the [Trait]s.
class TraitHiveProvider extends HiveBaseProvider<Trait> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch();

  @override
  String get boxName => 'trait';

  /// Returns a list of [Trait]s from the [Hive].
  Iterable<Trait> get traits => valuesSafe;

  @override
  void registerAdapters() {
    Hive.maybeRegisterAdapter(TraitAdapter());
  }

  /// Puts the provided [Trait] to the [Hive].
  Future<void> put(Trait trait) => putSafe(trait.trait, trait);

  /// Returns the stored [Trait] from the [Hive].
  Trait? get(Trait trait) => getSafe(trait.trait);

  /// Removes the stored [Trait] from the [Hive].
  Future<void> remove(Traits trait) => deleteSafe(trait.index);
}
