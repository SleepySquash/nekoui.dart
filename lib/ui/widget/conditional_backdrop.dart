import 'dart:ui';

import 'package:flutter/material.dart';

/// Wrapper around a [child] with or without [BackdropFilter] based on a
/// [condition].
class ConditionalBackdropFilter extends StatelessWidget {
  ConditionalBackdropFilter({
    Key? key,
    required this.child,
    this.condition = true,
    ImageFilter? filter,
    this.borderRadius,
  }) : super(key: key) {
    this.filter = filter ?? ImageFilter.blur(sigmaX: 10, sigmaY: 10);
  }

  /// [Widget] to apply [BackdropFilter] to.
  final Widget child;

  /// Indicator whether [BackdropFilter] should be enabled or not.
  final bool condition;

  /// Image filter to apply to the existing painted content before painting the
  /// [child].
  ///
  /// Defaults to [ImageFilter.blur] if not specified.
  late final ImageFilter filter;

  /// Border radius to clip the [child].
  ///
  /// Clips the [child] by a [ClipRect] if not specified, or by a [ClipRRect]
  /// otherwise.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      if (borderRadius != null) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: filter,
            blendMode: BlendMode.src,
            child: child,
          ),
        );
      }

      return ClipRect(
        child: BackdropFilter(
          filter: filter,
          blendMode: BlendMode.src,
          child: child,
        ),
      );
    }

    return child;
  }
}

class AnimatedBackdropFilter extends StatefulWidget {
  const AnimatedBackdropFilter({
    Key? key,
    this.sigma = 15,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.linear,
    this.onEnd,
  }) : super(key: key);

  final int sigma;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final void Function()? onEnd;

  @override
  State<AnimatedBackdropFilter> createState() => _AnimatedBackdropFilterState();
}

class _AnimatedBackdropFilterState extends State<AnimatedBackdropFilter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();

    _controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
        case AnimationStatus.dismissed:
          // No-op.
          break;

        case AnimationStatus.completed:
          widget.onEnd?.call();
          break;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(curve: widget.curve, parent: _controller),
      builder: (context, child) {
        return ConditionalBackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.sigma * _controller.value + 0.001,
            sigmaY: widget.sigma * _controller.value + 0.001,
          ),
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}
