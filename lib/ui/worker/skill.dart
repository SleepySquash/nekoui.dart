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

import '/domain/model/skill.dart';
import '/domain/service/notification.dart';
import '/domain/service/neko.dart';
import '/ui/home/flowchart/widget/skill_oval.dart';
import '/util/obs/obs.dart';

/// Worker responsible for showing a new [Chat] message notification.
class SkillWorker extends DisposableInterface {
  SkillWorker(
    this._nekoService,
    this._notificationService,
  );

  final NekoService _nekoService;
  final NotificationService _notificationService;

  final Map<String, _SkillListener> _listeners = {};
  StreamSubscription? _subscription;

  @override
  void onReady() {
    _nekoService.skills.forEach((k, v) =>
        _listeners[k] = _SkillListener(v, onLevel: _onLevel, onNew: _onNew));
    _subscription = _nekoService.skills.changes.listen((e) {
      switch (e.op) {
        case OperationKind.added:
          _listeners[e.key!] =
              _SkillListener(e.value!, onLevel: _onLevel, onNew: _onNew);
          _onNew(e.value!);
          break;

        case OperationKind.removed:
          _listeners.remove(e.key!)?.dispose();
          break;

        case OperationKind.updated:
          _listeners[e.key!] ??=
              _SkillListener(e.value!, onLevel: _onLevel, onNew: _onNew);
          _listeners[e.key!]?.init();
          break;
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _onNew(Skill skill) {
    var desc = SkillOval.describe(skill);
    _notificationService.notify(LocalNotification(
      title: 'New skill!',
      icon: desc.icon,
      text: desc.text,
    ));
  }

  void _onLevel(Skill skill) {
    var desc = SkillOval.describe(skill);
    _notificationService.notify(LocalNotification(
      title: 'New level!',
      icon: desc.icon,
      text: desc.text,
    ));
  }
}

class _SkillListener {
  _SkillListener(
    this.skill, {
    this.onNew,
    this.onLevel,
  }) {
    level = skill.level;

    _worker = ever(skill.value, (int value) {
      if (skill.level != level) {
        onLevel?.call(skill);
        level = skill.level;
      }
    });

    init();
  }

  final Skill skill;
  final void Function(Skill skill)? onNew;
  final void Function(Skill skill)? onLevel;

  final Map<String, _SkillListener> _listeners = {};
  StreamSubscription? _subscription;
  Worker? _worker;
  int? level;

  void init() {
    if (_subscription == null) {
      skill.skills?.forEach((k, v) =>
          _listeners[k] = _SkillListener(v, onLevel: onLevel, onNew: onNew));
    }

    _subscription ??= skill.skills?.changes.listen((e) {
      switch (e.op) {
        case OperationKind.added:
          _listeners[e.key!] =
              _SkillListener(e.value!, onLevel: onLevel, onNew: onNew);
          onNew?.call(e.value!);
          break;

        case OperationKind.removed:
          _listeners.remove(e.key!)?.dispose();
          break;

        case OperationKind.updated:
          break;
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
    _worker?.dispose();
  }
}
