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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/router.dart';
import '/util/message_popup.dart';
import 'controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SettingsController(Get.find()),
      builder: (SettingsController c) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.pin_drop),
                title: const Text('Геопозиция'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Logout'),
                onTap: () async {
                  if (await MessagePopup.alert('Are you sure?') == true) {
                    c.reset();
                    router.auth();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
