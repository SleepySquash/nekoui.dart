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

import '/domain/repository/flag.dart';
import '/provider/hive/flag.dart';

class FlagRepository implements AbstractFlagRepository {
  FlagRepository(this._local);

  final FlagHiveProvider _local;

  @override
  bool? get(Flags flag) => _local.get(flag);

  @override
  Future<void> set(Flags flag, bool value) => _local.put(flag, value);
}
