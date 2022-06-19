import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/ui/widget/conditional_backdrop.dart';
import '/ui/widget/delayed/delayed_opacity.dart';
import '/util/extension_utils.dart';
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
        child: AnimatedDelayedOpacity(
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
        child: AnimatedDelayedOpacity(
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
          const Color outline = Color(0xFF894B02);

          return Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedDelayedOpacity(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      e.unlock();
                      c.objects.remove(e);
                    },
                    child: Stack(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: max(60, constraints.maxHeight * 0.3),
                          ),
                          height: 285,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x00D7FAFC),
                                Color(0xFF81A6CD),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: max(60, constraints.maxWidth * 0.5),
                            ),
                            child: ResponsiveWrapper(
                              defaultScale: true,
                              breakpoints: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? const [
                                      ResponsiveBreakpoint.resize(400),
                                      ResponsiveBreakpoint.autoScale(600),
                                      ResponsiveBreakpoint.autoScale(800),
                                      ResponsiveBreakpoint.autoScale(1000),
                                      ResponsiveBreakpoint.autoScale(1200),
                                      ResponsiveBreakpoint.autoScale(2460),
                                    ]
                                  : const [
                                      ResponsiveBreakpoint.autoScaleDown(
                                        400,
                                        scaleFactor: 0.6,
                                      ),
                                      ResponsiveBreakpoint.autoScaleDown(
                                        680,
                                        scaleFactor: 0.5,
                                      ),
                                    ],
                              child: Column(
                                children: [
                                  if (e.by != null)
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Text(
                                        e.by!,
                                        style: TextStyle(
                                          color: const Color(0xFFFFC700),
                                          fontSize: 24,
                                          shadows: TextExtension.outline(
                                              color: outline),
                                        ),
                                      ),
                                    ),
                                  Text(
                                    e.text,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      shadows:
                                          TextExtension.outline(color: outline),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
