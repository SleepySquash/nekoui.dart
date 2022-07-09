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

import '/ui/home/neko/view.dart';
import '/ui/home/room/view.dart';
import '../../widget/neko/chibi/view.dart';
import 'controller.dart';

class ParkView extends StatelessWidget {
  const ParkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ParkController(Get.find()),
      builder: (ParkController c) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              InteractiveViewer(
                clipBehavior: Clip.none,
                minScale: 1,
                maxScale: 100,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/room/park.png',
                        isAntiAlias: false,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => NekoView.show(
                          context,
                          neko: c.nekoKey,
                          withWardrobe: false,
                        ),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: NekoChibi(key: c.nekoKey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  child: RoomView.needs(c.neko),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: RoomView.more(
                    context,
                    neko: c.nekoKey,
                    withWardrobe: false,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
