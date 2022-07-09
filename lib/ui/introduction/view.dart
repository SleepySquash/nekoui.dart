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
