import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nekoui/theme.dart';
import 'package:nekoui/ui/novel/src/widget/animated_appearence.dart';
import 'package:nekoui/ui/widget/conditional_backdrop.dart';

import 'controller.dart';
import 'model/object.dart';
import 'model/scenario.dart';

class Novel extends StatelessWidget {
  const Novel({
    Key? key,
    required this.scenario,
    this.onEnd,
  }) : super(key: key);

  /// [Scenario] to read in this [Novel].
  final Scenario scenario;

  /// Callback, called when the [Novel] ends reading its [scenario].
  ///
  /// Calls the [Navigator.pop], if `null`.
  final void Function()? onEnd;

  /// Displays a dialog with the provided [novel] above the current contents.
  static Future<T?> show<T extends Object?>({
    required BuildContext context,
    required Scenario scenario,
  }) {
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
        return themes.wrap(Novel(scenario: scenario));
      },
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init:
          NovelController(scenario, onEnd: onEnd ?? Navigator.of(context).pop),
      builder: (NovelController c) {
        return Obx(
          () => Stack(
            children: c.objects.map((e) => _buildObject(c, e)).toList(),
          ),
        );
      },
    );
  }

  /// Builds a [Widget] representation of the provided [NovelObject].
  Widget _buildObject(NovelController c, NovelObject e) {
    if (e is Background) {
      return Positioned.fill(
        child: AnimatedAppearance(
          beginOpacity: 0,
          endOpacity: 1,
          duration: e.duration,
          onEnd: e.unlock,
          child: Image(
            image: AssetImage('assets/images/background/${e.asset}'),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (e is Character) {
      return Positioned.fill(
        child: AnimatedAppearance(
          beginOpacity: 0,
          endOpacity: 1,
          duration: e.duration,
          onEnd: e.unlock,
          child: Image(
            image: AssetImage('assets/images/neko/${e.asset}'),
            fit: BoxFit.fitHeight,
          ),
        ),
      );
    } else if (e is Dialogue) {
      return LayoutBuilder(
        key: const Key('Dialog'),
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedAppearance(
              beginOpacity: 0,
              endOpacity: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (e.by != null)
                    Container(
                      margin: const EdgeInsets.only(left: 48),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          CustomBoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 8,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: ConditionalBackdropFilter(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          constraints: const BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            e.by!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      e.unlock();
                      c.objects.remove(e);
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(18, 9, 18, 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          CustomBoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 8,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: ConditionalBackdropFilter(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          constraints: BoxConstraints(
                            maxWidth: 600,
                            maxHeight: max(60, constraints.maxHeight * 0.2),
                          ),
                          width: 480,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              e.text,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (e is BackdropRect) {
      return ConditionalBackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(),
      );
    }

    return Container();
  }
}
