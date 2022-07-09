import 'package:flutter/material.dart';

import '../controller.dart';
import '/ui/widget/backdrop_button.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen(this.c, {Key? key}) : super(key: key);

  final NekoController c;

  @override
  Widget build(BuildContext context) {
    List<Widget> bubbles = c.activities
        .map(
          (e) => BackdropBubble(
            text: e.topic,
            icon: e.icon,
            color: e.icon.color,
            onTap: e.novel,
          ),
        )
        .toList();

    bool left = true;
    List<Widget> rows = [];
    for (int i = 0; i < bubbles.length; ++i) {
      var e = bubbles[i];
      rows.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (left) const Spacer(flex: 10),
            Flexible(flex: 10, child: e),
            if (!left) const Spacer(flex: 10),
          ],
        ),
      );

      left = !left;
    }

    return Stack(
      key: const Key('ActivityScreen'),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rows
                  .map((e) => Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: e,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
