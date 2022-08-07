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

import '/domain/model/application_settings.dart';
import 'base.dart';

/// [Hive] storage for [ApplicationSettings].
class ApplicationSettingsHiveProvider
    extends HiveBaseProvider<ApplicationSettings> {
  @override
  Stream<BoxEvent> get boxEvents => box.watch();

  @override
  String get boxName => 'application_settings';

  @override
  void registerAdapters() {
    Hive.maybeRegisterAdapter(ApplicationSettingsAdapter());
  }

  /// Returns the stored [ApplicationSettings] from [Hive].
  ApplicationSettings? get settings => getSafe(0);

  /// Saves the provided [ApplicationSettings] in [Hive].
  Future<void> set(ApplicationSettings settings) => putSafe(0, settings);

  /// Stores a new [locale] value of [ApplicationSettings.locale] to [Hive].
  Future<void> setLocale(String locale) =>
      putSafe(0, (box.get(0) ?? ApplicationSettings())..locale = locale);
}
