import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

import 'controller.dart';

class IntroductionView extends StatelessWidget {
  const IntroductionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: IntroductionController(Get.find()),
      builder: (IntroductionController c) {
        return Obx(() {
          Widget body;

          switch (c.stage.value) {
            case IntroductionStage.novel:
              body = Container();
              break;

            case IntroductionStage.name:
              body = Center(
                key: Key('${c.stage.value}'),
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
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: TextField(
                          controller: c.name,
                          decoration: const InputDecoration(
                            hintText: 'Введите сюда имя',
                            hintStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.white,
                            hoverColor: Colors.transparent,
                            filled: true,
                          ),
                          onChanged: (d) => c.nameIsEmpty.value = d.isEmpty,
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton.icon(
                        onPressed: c.nameIsEmpty.value ? null : c.accept,
                        icon: const Icon(Icons.done, color: Colors.white),
                        style:
                            ElevatedButton.styleFrom(primary: Colors.lightBlue),
                        label: const Text(
                          'Вот так!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              break;

            case IntroductionStage.character:
              body = Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  key: Key('${c.stage.value}'),
                  children: [
                    const Text('123'),
                    Expanded(
                      child: RiveAnimation.asset(
                        'assets/rive/chibi1.riv',
                        controllers: [c.animation],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                          4,
                          (i) => Container(
                            width: 64,
                            height: 64,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () =>
                              c.stage.value = IntroductionStage.name,
                          icon: const Icon(Icons.arrow_forward,
                              color: Colors.white),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlue),
                          label: const Text(
                            'Далее!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              break;
          }

          return Scaffold(
            body: AnimatedSwitcher(
              duration: 400.milliseconds,
              child: c.stage.value != IntroductionStage.novel
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/background/kitty.jpeg',
                            repeat: ImageRepeat.repeat,
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: 400.milliseconds,
                          child: body,
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
