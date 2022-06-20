import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class IntroductionView extends StatelessWidget {
  const IntroductionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: IntroductionController(Get.find()),
      builder: (IntroductionController c) {
        return Obx(() {
          return Scaffold(
            body: AnimatedSwitcher(
              duration: 400.milliseconds,
              child: c.naming.value
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/background/kitty.jpeg',
                            repeat: ImageRepeat.repeat,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BorderedText(
                                  child: Text(
                                    'Как зовут Вашу неко?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 300),
                                  child: TextField(
                                    controller: c.name,
                                    decoration: const InputDecoration(
                                      hintText: 'Введите сюда имя',
                                      hintStyle: TextStyle(color: Colors.black),
                                      fillColor: Colors.white,
                                      hoverColor: Colors.transparent,
                                      filled: true,
                                    ),
                                    onChanged: (d) =>
                                        c.nameIsEmpty.value = d.isEmpty,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                ElevatedButton.icon(
                                  onPressed:
                                      c.nameIsEmpty.value ? null : c.accept,
                                  icon: const Icon(Icons.done,
                                      color: Colors.white),
                                  label: const Text(
                                    'Вот так!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          );
        });
      },
    );
  }
}
