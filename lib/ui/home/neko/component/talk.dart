import 'package:flutter/material.dart';

import '../controller.dart';
import '/ui/widget/backdrop_button.dart';

class TalkScreen extends StatelessWidget {
  const TalkScreen(this.c, {Key? key}) : super(key: key);

  final NekoController c;

  @override
  Widget build(BuildContext context) {
    List<Widget> bubbles = c.topics.map((e) => e.build()).toList();

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
      key: const Key('TalkScreen'),
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BackdropIconButton(
              icon: Icons.chat,
              color: Colors.blue.withOpacity(0.4),
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
