import 'package:flutter/material.dart';

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({
    Key? key,
    required this.builder,
    this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.onDismiss,
  }) : super(key: key);

  final Widget Function(BuildContext, Widget?, Animation<double>) builder;
  final Widget? child;
  final Duration duration;
  final Curve curve;
  final void Function()? onDismiss;

  @override
  State<AnimatedDialog> createState() => AnimatedDialogState();

  static AnimatedDialogState? of(BuildContext context) {
    return context.findAncestorStateOfType<AnimatedDialogState>();
  }
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  void dismiss() {
    _controller.reverse();
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward()
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.dismissed:
            widget.onDismiss?.call();
            break;

          case AnimationStatus.forward:
          case AnimationStatus.reverse:
          case AnimationStatus.completed:
            // No-op.
            break;
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => widget.builder(
        context,
        child,
        CurvedAnimation(curve: widget.curve, parent: _controller),
      ),
      child: widget.child,
    );
  }
}
