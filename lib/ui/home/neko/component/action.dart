import 'package:flutter/material.dart';
import 'package:nekoui/ui/novel/novel.dart';
import 'package:nekoui/ui/widget/backdrop_button.dart';

import '../controller.dart';

class ActionScreen extends StatelessWidget {
  const ActionScreen(this.c, {Key? key}) : super(key: key);

  final NekoController c;

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: const Key('ActionScreen'),
      children: const [
        MouseRegion(cursor: SystemMouseCursors.grab),
      ],
    );
  }
}
