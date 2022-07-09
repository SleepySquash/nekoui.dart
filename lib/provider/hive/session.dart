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

import 'package:hive_flutter/adapters.dart';

import '../../domain/model/credentials.dart';
import 'base.dart';

// TODO: Encrypt stored data.
/// [Hive] storage for a [Credentials].
class SessionHiveProvider extends HiveBaseProvider<Credentials> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch(key: 0);

  @override
  String get boxName => 'session';

  @override
  void registerAdapters() {
    Hive.maybeRegisterAdapter(CredentialsAdapter());
  }

  /// Returns the stored [Credentials] from the [Hive].
  Credentials? getCredentials() => getSafe(0);

  /// Stores the provided [Credentials] to the [Hive].
  Future<void> setCredentials(Credentials credentials) =>
      putSafe(0, credentials);
}
