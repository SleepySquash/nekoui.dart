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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/widget/conditional_backdrop.dart';
import '/ui/widget/escape_popper.dart';
import '/ui/widget/neko/person.dart';
import 'component/action.dart';
import 'component/activity.dart';
import 'component/neko.dart';
import 'component/request.dart';
import 'component/talk.dart';
import 'controller.dart';

class NekoView extends StatefulWidget {
  const NekoView({Key? key, this.neko, this.withWardrobe = true})
      : super(key: key);

  final GlobalKey? neko;
  final bool withWardrobe;

  /// Displays a dialog with the provided [gallery] above the current contents.
  static Future<T?> show<T extends Object?>(
    BuildContext context, {
    GlobalKey? neko,
    bool withWardrobe = true,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        final CapturedThemes themes = InheritedTheme.capture(
          from: context,
          to: Navigator.of(context, rootNavigator: true).context,
        );
        return themes.wrap(
          NekoView(
            neko: neko,
            withWardrobe: withWardrobe,
          ),
        );
      },
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      useRootNavigator: false,
    );
  }

  @override
  State<NekoView> createState() => _NekoViewState();
}

class _NekoViewState extends State<NekoView>
    with SingleTickerProviderStateMixin {
  /// [AnimationController] controlling the opening and closing animation.
  late final AnimationController _fading;

  /// Pops this [NekoView] route off the [Navigator].
  void Function()? _pop;

  /// [Rect] of an [Object] to animate this [NekoView] from/to.
  late Rect _bounds;

  /// Discard the first [LayoutBuilder] frame since no widget is drawn yet.
  bool _firstLayout = true;

  @override
  void initState() {
    _fading = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )
      ..addStatusListener(
        (status) {
          switch (status) {
            case AnimationStatus.dismissed:
              _pop?.call();
              break;

            case AnimationStatus.reverse:
            case AnimationStatus.forward:
            case AnimationStatus.completed:
              // No-op.
              break;
          }
        },
      )
      ..forward();

    _bounds = _calculatePosition() ?? Rect.zero;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EscapePopper(
      onEscape: _dismiss,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_firstLayout) {
            _pop = Navigator.of(context).pop;
            _firstLayout = false;
          }

          var curved = CurvedAnimation(
            parent: _fading,
            curve: Curves.ease,
            reverseCurve: Curves.ease,
          );

          var fade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _fading,
            curve: const Interval(0, 0.3, curve: Curves.ease),
          ));

          RelativeRectTween tween() => RelativeRectTween(
                begin: RelativeRect.fromSize(_bounds, constraints.biggest),
                end: RelativeRect.fill,
              );

          return GetBuilder(
            init: NekoController(
              Get.find(),
              withWardrobe: widget.withWardrobe,
            ),
            builder: (NekoController c) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (c.screen.value == null) {
                        _dismiss();
                      } else {
                        c.screen.value = null;
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _fading,
                      builder: (context, child) => ConditionalBackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 0.01 + 15 * _fading.value,
                          sigmaY: 0.01 + 15 * _fading.value,
                        ),
                        child: Container(),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _fading,
                    builder: (context, child) {
                      return PositionedTransition(
                        rect: tween().animate(curved),
                        child: FadeTransition(
                          opacity: fade,
                          child: SafeArea(child: NekoPerson(Get.find())),
                        ),
                      );
                    },
                  ),
                  ..._buildInterface(c),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildInterface(NekoController c) {
    Widget screen(NekoViewScreen? current) {
      switch (current) {
        case NekoViewScreen.request:
          return RequestScreen(c);

        case NekoViewScreen.action:
          return ActionScreen(c);

        case NekoViewScreen.activity:
          return ActivityScreen(c);

        case NekoViewScreen.talk:
          return TalkScreen(c);

        default:
          return NekoScreen(c);
      }
    }

    return [
      AnimatedBuilder(
        animation: _fading,
        builder: (_, child) => Opacity(opacity: _fading.value, child: child!),
        child: Obx(
          () => AnimatedSwitcher(
            duration: 200.milliseconds,
            child: screen(c.screen.value),
          ),
        ),
      ),
      AnimatedBuilder(
        animation: _fading,
        builder: (_, child) => Opacity(opacity: _fading.value, child: child!),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16, right: 16),
            child: Obx(
              () => FloatingActionButton(
                mini: false,
                onPressed: c.screen.value == null
                    ? _dismiss
                    : () {
                        switch (c.screen.value) {
                          case NekoViewScreen.action:
                          case NekoViewScreen.activity:
                          case NekoViewScreen.request:
                            c.screen.value = null;
                            break;

                          case NekoViewScreen.talk:
                            if (c.topic.value == null) {
                              c.screen.value = null;
                            } else {
                              c.topic.value = null;
                            }
                            break;

                          default:
                            c.screen.value = null;
                            break;
                        }
                      },
                child: c.screen.value == null
                    ? const Icon(Icons.close_rounded)
                    : const Icon(Icons.arrow_back),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  /// Starts a dismiss animation.
  void _dismiss() {
    _bounds = _calculatePosition() ?? _bounds;
    _fading.reverse();
  }

  /// Returns a [Rect] of an [Object] identified by the provided initial
  /// [GlobalKey].
  Rect? _calculatePosition() => widget.neko?.globalPaintBounds;
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final matrix = renderObject?.getTransformTo(null);

    if (matrix != null && renderObject?.paintBounds != null) {
      final rect = MatrixUtils.transformRect(matrix, renderObject!.paintBounds);
      return rect;
    } else {
      return null;
    }
  }
}
