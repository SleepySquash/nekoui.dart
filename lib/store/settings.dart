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
import 'package:hive/hive.dart';

import '/domain/model/application_settings.dart';
import '/domain/repository/settings.dart';
import '/provider/hive/application_settings.dart';

/// Application settings repository.
class SettingsRepository extends DisposableInterface
    implements AbstractSettingsRepository {
  SettingsRepository(this._settingsLocal);

  @override
  final Rx<ApplicationSettings?> applicationSettings = Rx(null);

  /// [ApplicationSettings] local [Hive] storage.
  final ApplicationSettingsHiveProvider _settingsLocal;

  /// [ApplicationSettingsHiveProvider.boxEvents] subscription.
  StreamIterator? _settingsSubscription;

  @override
  void onInit() {
    applicationSettings.value = _settingsLocal.settings;
    _initSettingsSubscription();
    super.onInit();
  }

  @override
  void onClose() {
    _settingsSubscription?.cancel();
    super.onClose();
  }

  @override
  Future<void> clearCache() => _settingsLocal.clear();

  @override
  Future<void> setLocale(String locale) => _settingsLocal.setLocale(locale);

  /// Initializes [ApplicationSettingsHiveProvider.boxEvents] subscription.
  Future<void> _initSettingsSubscription() async {
    _settingsSubscription = StreamIterator(_settingsLocal.boxEvents);
    while (await _settingsSubscription!.moveNext()) {
      BoxEvent event = _settingsSubscription!.current;
      if (event.deleted) {
        applicationSettings.value = null;
      } else {
        applicationSettings.value = event.value;
        applicationSettings.refresh();
      }
    }
  }
}
