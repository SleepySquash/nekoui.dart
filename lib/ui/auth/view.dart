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

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AuthController(Get.find()),
      builder: (AuthController c) {
        return Obx(() {
          if (c.status.value.isLoading) {
            return const Scaffold(body: CircularProgressIndicator());
          }

          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Spacer(),
                  const Text('NekoUI'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: router.introduction,
                    style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                    child: const Text(
                      'Play',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (await MessagePopup.alert('Are you sure?') == true) {
                        c.clean();
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.lightBlue),
                    child: const Text(
                      'Clear cache',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
