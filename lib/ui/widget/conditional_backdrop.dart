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
