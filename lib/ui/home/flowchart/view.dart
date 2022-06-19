import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'widget/skill_oval.dart';
import '/ui/widget/delayed/delayed_scale.dart';
import '/domain/model/skill.dart';
import 'controller.dart';
import 'widget/hex_grid.dart';

class FlowchartView extends StatelessWidget {
  const FlowchartView({Key? key}) : super(key: key);

  /// Displays a dialog with the provided [novel] above the current contents.
  static Future<T?> show<T extends Object?>({required BuildContext context}) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        final CapturedThemes themes = InheritedTheme.capture(
          from: context,
          to: Navigator.of(context, rootNavigator: true).context,
        );
        return themes.wrap(const FlowchartView());
      },
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: 300.milliseconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      onKeyEvent: (k) {
        if (k is KeyUpEvent && k.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
        }
      },
      focusNode: FocusNode(),
      child: GetBuilder(
        init: FlowchartController(Get.find(), Get.find()),
        builder: (FlowchartController c) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.book)),
                    Tab(icon: Icon(Icons.interests)),
                    Tab(icon: Icon(Icons.move_down)),
                  ],
                ),
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _skillsView(c, context),
                  Text('TODO'),
                  Text('TODO'),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: Navigator.of(context).pop,
                child: const Icon(Icons.close),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _skillsView(FlowchartController c, BuildContext context) {
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
