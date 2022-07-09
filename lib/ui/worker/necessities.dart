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

import 'package:get/get.dart';

import '/domain/notification_id.dart';
import '/domain/repository/neko.dart';
import '/domain/service/neko.dart';
import '/domain/service/notification.dart';

class NecessitiesWorker extends DisposableInterface {
  NecessitiesWorker(
    this._nekoService,
    this._notificationService,
  );

  final NekoService _nekoService;
  final NotificationService _notificationService;

  late final List<Worker> _workers;

  @override
  void onInit() {
    _notificationService.cancel(NotificationId.hunger);
    _notificationService.cancel(NotificationId.thirst);
    _notificationService.cancel(NotificationId.social);
    _notificationService.cancel(NotificationId.toilet);
    _notificationService.cancel(NotificationId.energy);
    _notificationService.cancel(NotificationId.cleaness);

    _hunger(_nekoService.neko.value.necessities.hunger.value);
    _thirst(_nekoService.neko.value.necessities.thirst.value);
    _social(_nekoService.neko.value.necessities.social.value);
    _clean(_nekoService.neko.value.necessities.cleanness.value);

    _workers = [
      ever(_nekoService.neko.value.necessities.hunger, _hunger),
      ever(_nekoService.neko.value.necessities.thirst, _thirst),
      ever(_nekoService.neko.value.necessities.social, _social),
      ever(_nekoService.neko.value.necessities.cleanness, _clean),
    ];

    super.onInit();
  }

  @override
  void onClose() {
    for (var e in _workers) {
      e.dispose();
    }

    super.onClose();
  }

  void _hunger(double value) {
    _schedule(
      value: value,
      id: NotificationId.hunger,
      inSecond: AbstractNekoRepository.hungerInSecond,
      body: 'Я проголодалась!! >3<',
    );
  }

  void _thirst(double value) {
    _schedule(
      value: value,
      id: NotificationId.thirst,
      inSecond: AbstractNekoRepository.thirstInSecond,
      body: 'Хотю водички!! >.>',
    );
  }

  void _social(double value) {
    _schedule(
      value: value,
      id: NotificationId.social,
      inSecond: AbstractNekoRepository.socialInSecond,
      body: 'Мне очень одиноко без тебя...',
    );
  }

  void _clean(double value) {
    _schedule(
      value: value,
      id: NotificationId.cleaness,
      inSecond: AbstractNekoRepository.dirtyInSecond,
      body: 'П-помой меня, пожалуйста т.т',
    );
  }

  void _schedule({
    required double value,
    required double inSecond,
    required int id,
    required String body,
  }) {
    Duration when = Duration(seconds: value ~/ inSecond);

    if (when.inSeconds > 120) {
      _notificationService.schedule(
        _nekoService.neko.value.name.value,
        id: id,
        body: body,
        at: Duration(seconds: value ~/ inSecond),
      );
    }
  }
}
