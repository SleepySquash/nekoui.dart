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

    const double size = 90;

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
                      child: SizedBox(
                        // width: size,
                        // height: size,
                        child: Center(child: e),
                      ),
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

    return Padding(
      padding: const EdgeInsets.only(left: size / 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: rows,
      ),
    );
  }
}
