import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/domain/service/neko.dart';
import '/ui/widget/neko.dart';
import 'controller.dart';

class RoomView extends StatelessWidget {
  const RoomView(this._neko, {Key? key}) : super(key: key);

  final NekoService _neko;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RoomController(_neko),
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
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/room/room.png',
                        isAntiAlias: false,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => c.showNeko(context),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: NekoWidget(
                            _neko,
                            key: c.nekoKey,
                            isPerson: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: _more(c, context),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  child: _needs(c),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _more(RoomController c, BuildContext context) {
    return CircularMenu(
      key: c.fabKey,
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
            c.showNeko(context);
            c.fabKey.currentState?.reverseAnimation();
          },
        ),
        CircularMenuItem(
          icon: Icons.warehouse,
          boxShadow: const [],
          onTap: () {
            c.showInventory(context);
            c.fabKey.currentState?.reverseAnimation();
          },
        ),
        CircularMenuItem(
          icon: Icons.book,
          boxShadow: const [],
          onTap: () {
            c.fabKey.currentState?.reverseAnimation();
          },
        ),
        CircularMenuItem(
          icon: Icons.map,
          boxShadow: const [],
          onTap: () {
            c.showMap(context);
            c.fabKey.currentState?.reverseAnimation();
          },
        ),
        CircularMenuItem(
          icon: Icons.settings,
          boxShadow: const [],
          onTap: () {
            c.fabKey.currentState?.reverseAnimation();
          },
        ),
      ],
    );
  }

  Widget _needs(RoomController c) {
    return Obx(() {
      var needs = c.neko.value?.necessities;

      Widget _need(IconData icon, int? value) {
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
          _need(Icons.fastfood, needs?.hunger.value),
          _need(Icons.local_drink_rounded, needs?.thirst.value),
          _need(Icons.invert_colors_rounded, needs?.cleanness.value),
          _need(Icons.bedtime_rounded, needs?.energy.value),
          _need(Icons.chat_bubble_rounded, needs?.social.value),
        ],
      );
    });
  }
}
