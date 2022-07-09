import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'component/interest.dart';
import 'component/progress.dart';
import 'component/skill.dart';
import 'widget/keep_alive.dart';

import 'controller.dart';

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
        init: FlowchartController(Get.find()),
        builder: (FlowchartController c) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: TabBar(
                  tabs: [
                    const Tab(text: 'Skills', icon: Icon(Icons.book)),
                    const Tab(text: 'Interests', icon: Icon(Icons.interests)),
                    Tab(
                      text: 'Progress',
                      icon: Badge(
                        badgeContent: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            '1',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        position: BadgePosition.bottomEnd(),
                        child: const Icon(Icons.move_down),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  KeepAlivePage(child: SkillTab(c)),
                  KeepAlivePage(child: InterestTab(c)),
                  KeepAlivePage(child: ProgressTab(c)),
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
}
