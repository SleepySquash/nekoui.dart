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

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller.dart';
import '../widget/hex_grid.dart';
import '../widget/skill_oval.dart';
import '/domain/model/skill.dart';
import '/ui/widget/delayed/delayed_scale.dart';
import '/util/obs/obs.dart';

class SkillTab extends StatelessWidget {
  const SkillTab(this.c, {Key? key}) : super(key: key);

  final FlowchartController c;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 3,
      transformationController: c.initial.transformation,
      child: Center(
        child: Obx(() {
          Iterable<MapEntry<String, Skill>> skills = c.skills.entries;
          return HexGrid(
            children: skills
                .mapIndexed((i, e) => AnimatedDelayedScale(
                      delay: Duration(milliseconds: 5 * i),
                      child: SkillOval(e),
                    ))
                .toList(),
          );
        }),
      ),
    );
  }
}

class SkillSubView extends StatelessWidget {
  const SkillSubView({
    Key? key,
    required this.entry,
  }) : super(key: key);

  final MapEntry<String, Skill> entry;

  @override
  Widget build(BuildContext context) {
    var skills = entry.value.skills ?? RxObsMap({});
    // skills
    //     .addAll({for (var i in List.generate(30, (i) => i)) '$i': Skill('$i')});

    var desc = SkillOval.describe(entry.value);

    return KeyboardListener(
      autofocus: true,
      onKeyEvent: (k) {
        if (k is KeyUpEvent && k.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
        }
      },
      focusNode: FocusNode(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, constraints) {
          return InteractiveViewer(
            minScale: 0.2,
            maxScale: 3,
            constrained: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Center(
                child: HexGrid(
                  children: [
                    AnimatedDelayedScale(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Card(
                          elevation: 8,
                          // color: Theme.of(context).colorScheme.surfaceVariant,
                          color: desc.color ?? Colors.lightBlue,
                          child: InkWell(
                            onTap: Navigator.of(context).pop,
                            child: DefaultTextStyle(
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              child: Container(
                                width: 240,
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Icon(
                                      desc.icon,
                                      size: (desc.size ?? 24) * 2,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      desc.text,
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          decoration: const BoxDecoration(
                                            color: Color(0x55000000),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text('${entry.value.level}'),
                                        ),
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: LinearProgressIndicator(
                                              minHeight: 20,
                                              value: entry.value.progress,
                                              backgroundColor:
                                                  const Color(0x55000000),
                                              color: const Color(0xAAFFFFFF),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ...skills.entries.mapIndexed((i, e) => AnimatedDelayedScale(
                          delay: Duration(milliseconds: 5 * i),
                          child: SkillOval(e),
                        ))
                  ],
                ),
              ),
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: Navigator.of(context).pop,
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
    );
  }
}
