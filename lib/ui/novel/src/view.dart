import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/dialogue.dart';
import '/ui/widget/conditional_backdrop.dart';
import '/ui/widget/delayed/delayed_opacity.dart';
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
    required List<ScenarioLine> scenario,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Novel(scenario: Scenario(scenario));
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Threshold(0),
            reverseCurve: Curves.linear,
          ),
          child: child,
        );
      },
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: 200.milliseconds,
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
        key: e.key,
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
        key: e.key,
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
      return Align(
        key: e.key,
        alignment: Alignment.bottomCenter,
        child: AnimatedDelayedOpacity(
          child: GestureDetector(
            onTap: () {
              e.unlock();
              // c.objects.remove(e);
            },
            child: DialogueWidget(text: e.text, by: e.by),
          ),
        ),
      );
    } else if (e is BackdropRect) {
      return AnimatedBackdropFilter(
        duration: e.duration,
        onEnd: e.unlock,
        child: Container(),
      );
    }

    return Container();
  }
}
