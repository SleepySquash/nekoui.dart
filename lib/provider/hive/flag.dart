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

import '/domain/repository/flag.dart';
import 'base.dart';

/// [Hive] storage for the [Neko].
class FlagHiveProvider extends HiveBaseProvider<bool> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch();

  @override
  String get boxName => 'flag';

  @override
  void registerAdapters() {}

  /// Puts the provided [HiveNeko] to the [Hive].
  Future<void> put(Flags flag, bool value) => putSafe(flag.index, value);

  /// Returns the stored [HiveNeko] from the [Hive].
  bool? get(Flags flag) => getSafe(flag.index);

  /// Removes the store [HiveNeko] from the [Hive].
  Future<void> remove(Flags flag) => deleteSafe(flag.index);
}
