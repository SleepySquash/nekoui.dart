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

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../component/skill.dart';
import '/domain/model/skill.dart';

class SkillOval extends StatelessWidget {
  const SkillOval(this.entry, {Key? key}) : super(key: key);

  final MapEntry<String, Skill> entry;

  @override
  Widget build(BuildContext context) {
    var desc = describe(entry.value);
    return SizedBox(
      width: 90,
      height: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Badge(
            badgeContent: Text(
              '${entry.value.level}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            badgeColor: desc.color ?? Colors.blueGrey,
            position: BadgePosition.bottomEnd(bottom: -2, end: -2),
            child: FloatingActionButton(
              heroTag: entry.key,
              backgroundColor: desc.color,
              shape: const CircleBorder(),
              onPressed: () {
                // if (entry.value.skills?.isNotEmpty == true) {
                Navigator.of(context).push(
                  // MaterialPageRoute(builder: (c) => SkillSubView(entry: entry)),
                  PageTransition(
                    child: SkillSubView(entry: entry),
                    type: PageTransitionType.fade,
                    alignment: Alignment.center,
                  ),
                );
                // }
              },
              child: Icon(desc.icon, size: desc.size ?? 32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc.text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static SkillDescription describe(Skill entry) {
    switch (entry.name) {
      case 'basic':
        return const SkillDescription(
          icon: Icons.abc,
          text: 'Базовые\nпотребности',
          color: Colors.blue,
          size: 48,
        );

      case 'eating':
        return const SkillDescription(
          icon: Icons.no_food,
          text: 'Питание',
          color: Colors.lightGreen,
        );

      case 'naturalNeed':
        return const SkillDescription(
          icon: Icons.wc,
          text: 'Естественная\nнужда',
          color: Colors.brown,
        );

      case 'showering':
        return const SkillDescription(
          icon: Icons.shower,
          text: 'Чистота',
          color: Colors.lightBlue,
        );

      case 'sleeping':
        return const SkillDescription(
          icon: Icons.bed_rounded,
          text: 'Сон',
          color: Colors.blueGrey,
        );

      case 'talking':
        return const SkillDescription(
          icon: Icons.chat_bubble_rounded,
          text: 'Общение',
          color: Colors.teal,
        );

      case 'drawing':
        return const SkillDescription(
          icon: Icons.draw,
          text: 'Рисование',
          color: Colors.teal,
        );

      case 'anatomy':
        return const SkillDescription(
          icon: Icons.accessibility_new,
          text: 'Анатомия',
          color: Colors.teal,
        );

      default:
        return const SkillDescription(
          icon: Icons.device_unknown,
          text: '...',
          color: Colors.grey,
        );
    }
  }
}

class SkillDescription {
  const SkillDescription({
    required this.text,
    required this.icon,
    this.size,
    this.color,
  });

  final Color? color;
  final IconData icon;
  final double? size;
  final String text;
}
