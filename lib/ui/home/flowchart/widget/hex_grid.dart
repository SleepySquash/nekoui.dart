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

import 'dart:collection';

import 'package:flutter/material.dart';

class HexGrid extends StatelessWidget {
  const HexGrid({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    SplayTreeMap<int, SplayTreeMap<int, Widget>> map =
        SplayTreeMap((int k1, int k2) {
      return k2.compareTo(k1);
    });

    int x = 0, y = 0;
    int maxX = 0, maxY = 0;

    Alignment moveTo = Alignment.centerRight;

    void placeAt(int x, int y, Widget child) {
      map[y] = (map[y] ?? SplayTreeMap());
      map[y]![x] = child;
    }

    for (var i = 0; i < children.length; ++i) {
      placeAt(x, y, children[i]);

      if (moveTo == Alignment.centerRight) {
        ++x;

        if (x >= maxX + 1) {
          moveTo = Alignment.bottomCenter;
          maxX++;
        }
      } else if (moveTo == Alignment.bottomCenter) {
        --y;

        if (y <= -maxY - 1) {
          moveTo = Alignment.centerLeft;
          maxY++;
        }
      } else if (moveTo == Alignment.centerLeft) {
        --x;

        if (x <= -maxX) {
          moveTo = Alignment.topCenter;
        }
      } else if (moveTo == Alignment.topCenter) {
        ++y;

        if (y >= maxY) {
          moveTo = Alignment.centerRight;
        }
      }
    }

    List<Widget> rows = [];
    for (var e in map.entries) {
      rows.add(
        Transform.translate(
          offset: Offset.zero,
          // offset: e.key.isEven ? Offset.zero : const Offset(-size / 2, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: e.value.values
                .map((e) => Padding(
                      padding: const EdgeInsets.all(1),
                      child: SizedBox(child: Center(child: e)),
                    ))
                .toList(),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}
