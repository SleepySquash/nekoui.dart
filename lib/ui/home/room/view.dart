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

import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/domain/model/neko.dart';
import '/domain/service/environment.dart';
import '/router.dart';
import '/ui/home/neko/view.dart';
import '/ui/home/room/components/room.dart';
import '/ui/widget/neko/chibi/view.dart';
import 'controller.dart';

class RoomView extends StatelessWidget {
  const RoomView({Key? key}) : super(key: key);

  static Widget weather(Rx<Weather> weather, RxDouble temperature) {
    return Obx(() {
      Widget? icon;

      bool isLoading = false;
      Widget _icon(IconData icon) => Icon(
            icon,
            size: 32,
            color: Colors.white,
          );

      switch (weather.value) {
        case Weather.clear:
          icon = _icon(Icons.sunny);
          break;

        case Weather.clouds:
          icon = _icon(Icons.cloud);
          break;

        case Weather.drizzle:
          icon = _icon(Icons.water_drop);
          break;

        case Weather.fog:
          icon = _icon(Icons.foggy);
          break;

        case Weather.rain:
          icon = _icon(Icons.water_drop);
          break;

        case Weather.snow:
          icon = _icon(Icons.snowing);
          break;

        case Weather.thunderstorm:
          icon = _icon(Icons.thunderstorm);
          break;

        case Weather.unknown:
          icon = _icon(Icons.device_unknown);
          break;

        default:
          isLoading = true;
          break;
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          if (isLoading)
            const CircularProgressIndicator()
          else ...[
            icon!,
            const SizedBox(height: 10),
            Text(
              '${temperature.value} ℃',
              style: const TextStyle(color: Colors.white),
            ),
          ]
        ],
      );
    });
  }

  static Widget needs(Rx<Neko?> neko) {
    return Obx(() {
      var needs = neko.value?.necessities;

      Widget _need(IconData icon, double? value) {
        Color color = Colors.white;

        if (value != null) {
          if (value <= 100) {
            if (value <= 100 && value >= 50) {
              color = Color.lerp(
                    Colors.white,
                    Colors.yellow,
                    1 - (value - 50) / 50,
                  ) ??
                  Colors.white;
            } else {
              color = Color.lerp(
                    Colors.yellow,
                    Colors.red,
                    1 - value / 50,
                  ) ??
                  Colors.white;
            }
          }
        }

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        );
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _need(Icons.restaurant_rounded, needs?.hunger.value),
          _need(Icons.local_drink_rounded, needs?.thirst.value),
          _need(Icons.wc_rounded, needs?.naturalNeed.value),
          _need(Icons.shower_rounded, needs?.cleanness.value),
          _need(Icons.bedtime_rounded, needs?.energy.value),
          _need(Icons.question_answer_rounded, needs?.social.value),
        ],
      );
    });
  }

  static Widget more(
    BuildContext context, {
    GlobalKey? neko,
    bool withWardrobe = true,
  }) {
    GlobalKey<CircularMenuState> fabKey = GlobalKey<CircularMenuState>();
    return CircularMenu(
      key: fabKey,
      alignment: Alignment.bottomRight,
      toggleButtonBoxShadow: const [],
      radius: 180,
      startingAngleInRadian: pi,
      endingAngleInRadian: 3 * pi / 2,
      curve: Curves.ease,
      reverseCurve: Curves.ease,
      animationDuration: const Duration(milliseconds: 200),
      items: [
        CircularMenuItem(
          icon: Icons.person,
          color: Colors.teal,
          enableBadge: true,
          badgeColor: Colors.amber,
          badgeLabel: '3',
          badgeRadius: 10,
          badgeTextColor: Colors.black,
          badgeRightOffet: 5,
          badgeTopOffet: 5,
          boxShadow: const [],
          onTap: () {
            NekoView.show(context, neko: neko, withWardrobe: withWardrobe);
            fabKey.currentState?.reverseAnimation();
          },
        ),
        CircularMenuItem(
          icon: Icons.warehouse,
          boxShadow: const [],
          onTap: () {
            router.inventory();
            fabKey.currentState?.reverseAnimation();
          },
        ),
        CircularMenuItem(
          icon: Icons.book,
          boxShadow: const [],
          onTap: () {
            router.flowchart();
            fabKey.currentState?.reverseAnimation();
          },
        ),
        CircularMenuItem(
          icon: Icons.map,
          boxShadow: const [],
          onTap: () {
            router.map();
            fabKey.currentState?.reverseAnimation();
          },
        ),
        CircularMenuItem(
          icon: Icons.more_horiz,
          boxShadow: const [],
          onTap: () {
            router.more();
            fabKey.currentState?.reverseAnimation();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RoomController(Get.find(), Get.find()),
      builder: (RoomController c) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              InteractiveViewer(
                clipBehavior: Clip.hardEdge,
                minScale: 0.01,
                maxScale: 100,
                constrained: false,
                child: SizedBox(
                  width: 1024 + 16 * 100 + 1024,
                  height: 1024 + 8 * 100 + 1024,
                  child: RoomWidget(c),
                ),
                // child: Container(
                //   padding: const EdgeInsets.all(256),
                //   child: Stack(
                //     children: [
                //       RoomWidget(c),
                //       Positioned(
                //         left: c.x.value,
                //         top: c.y.value,
                //         width: 256,
                //         height: 256,
                //         child: GestureDetector(
                //           onTap: () {
                //             NekoView.show(context, neko: c.nekoKey);
                //             // TODO: Close FAB aswell.
                //           },
                //           child: NekoChibi(key: c.nekoKey),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  child: weather(c.weather, c.temperature),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  child: needs(c.neko),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: more(context, neko: c.nekoKey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
