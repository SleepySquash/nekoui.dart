import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nekoui/domain/service/environment.dart';
import 'package:nekoui/ui/home/room/components/room.dart';

import '/domain/model/neko.dart';
import '/router.dart';
import '/ui/home/neko/view.dart';
import '../../widget/neko/chibi/view.dart';
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
                clipBehavior: Clip.none,
                minScale: 1,
                maxScale: 100,
                child: Stack(
                  children: [
                    RoomWidget(c),
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/room/room.png',
                        isAntiAlias: false,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          NekoView.show(context, neko: c.nekoKey);
                          // TODO: Close FAB aswell.
                        },
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
