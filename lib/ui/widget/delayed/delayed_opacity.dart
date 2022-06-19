import 'package:flutter/material.dart';

class AnimatedDelayedOpacity extends StatefulWidget {
  const AnimatedDelayedOpacity({
    Key? key,
    this.begin = 0,
    this.end = 1,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.linear,
    this.onEnd,
  }) : super(key: key);

  final double begin;
  final double end;
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final void Function()? onEnd;

  @override
  State<AnimatedDelayedOpacity> createState() => _AnimatedDelayedOpacityState();
}

class _AnimatedDelayedOpacityState extends State<AnimatedDelayedOpacity> {
  late double opacity;

  @override
  void initState() {
    opacity = widget.begin;
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() => opacity = widget.end);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: widget.duration,
      curve: widget.curve,
      onEnd: widget.onEnd,
      child: widget.child,
    );
  }
}
