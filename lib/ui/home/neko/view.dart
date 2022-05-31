import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/domain/service/neko.dart';
import '/ui/widget/conditional_backdrop.dart';
import '/ui/widget/neko.dart';

import 'controller.dart';

class NekoView extends StatefulWidget {
  const NekoView(
    this._neko, {
    Key? key,
    this.globalKey,
  }) : super(key: key);

  final GlobalKey? globalKey;

  final NekoService _neko;

  /// Displays a dialog with the provided [gallery] above the current contents.
  static Future<T?> show<T extends Object?>({
    required BuildContext context,
    required NekoView view,
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
        return themes.wrap(view);
      },
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
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
    return LayoutBuilder(
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

        return Stack(
          children: [
            AnimatedBuilder(
              animation: _fading,
              builder: (context, child) => ConditionalBackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0.1 + 15 * _fading.value,
                  sigmaY: 0.1 + 15 * _fading.value,
                ),
                child: Container(),
              ),
            ),
            AnimatedBuilder(
              animation: _fading,
              builder: (context, child) {
                return PositionedTransition(
                  rect: tween().animate(curved),
                  child: FadeTransition(
                    opacity: fade,
                    child: GetBuilder(
                      init: NekoController(),
                      builder: (NekoController c) {
                        return GestureDetector(
                          behavior: HitTestBehavior.deferToChild,
                          onTap: _dismiss,
                          child: NekoWidget(widget._neko),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            ..._buildInterface(),
          ],
        );
      },
    );
  }

  List<Widget> _buildInterface() => [];

  /// Starts a dismiss animation.
  void _dismiss() {
    _bounds = _calculatePosition() ?? _bounds;
    _fading.reverse();
  }

  /// Returns a [Rect] of an [Object] identified by the provided initial
  /// [GlobalKey].
  Rect? _calculatePosition() => widget.globalKey?.globalPaintBounds;
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
