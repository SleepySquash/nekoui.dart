import 'package:flutter/material.dart';

import '../controller.dart';
import '/router.dart';
import '/ui/widget/backdrop_button.dart';
import '/ui/widget/delayed/delayed_slide.dart';

class NekoScreen extends StatelessWidget {
  const NekoScreen(this.c, {Key? key}) : super(key: key);

  final NekoController c;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Widget _animated(Widget child, [int i = 0]) {
        return AnimatedDelayedSlide(
          duration: Duration(milliseconds: 400 + 100 * i),
          child: child,
        );
      }

      bool dense = constraints.maxHeight < 500;
      bool text = constraints.maxWidth >= 500;

      return Stack(
        key: const Key('NekoScreen'),
        children: [
          Align(
            alignment: dense ? Alignment.topRight : Alignment.centerRight,
            child: Transform.scale(
              scale: dense ? 0.7 : 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: _animated(
                        BackdropIconButton(
                          icon: Icons.help,
                          text: text ? 'Просьба' : null,
                          onTap: () => c.open(NekoViewScreen.request),
                        ),
                        0,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Flexible(
                      child: _animated(
                        BackdropIconButton(
                          icon: Icons.chat_rounded,
                          text: text ? 'Поговорить' : null,
                          onTap: () => c.open(NekoViewScreen.talk),
                        ),
                        1,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Flexible(
                      child: _animated(
                        BackdropIconButton(
                          icon: Icons.attractions,
                          text: text ? 'Занятие' : null,
                          onTap: () => c.open(NekoViewScreen.activity),
                        ),
                        2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Flexible(
                      child: _animated(
                        BackdropIconButton(
                          icon: Icons.handshake_rounded,
                          text: text ? 'Действие' : null,
                          onTap: () => c.open(NekoViewScreen.action),
                        ),
                        3,
                      ),
                    ),
                    if (c.withWardrobe) ...[
                      const SizedBox(height: 15),
                      Flexible(
                        child: _animated(
                          BackdropIconButton(
                            icon: Icons.face,
                            text: text ? 'Гардероб' : null,
                            onTap: router.wardrobe,
                          ),
                          4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.neko.value?.mood.value.asEnum.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      const Icon(Icons.favorite, size: 36, color: Colors.red),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '${c.neko.value?.affinity.value}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
