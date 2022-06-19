import 'package:flutter/material.dart';

class AnimatedDelayedScale extends StatefulWidget {
  const AnimatedDelayedScale({
    Key? key,
    this.begin = 0,
    this.end = 1,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOutQuart,
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
  State<AnimatedDelayedScale> createState() => _AnimatedDelayedScaleState();
}

class _AnimatedDelayedScaleState extends State<AnimatedDelayedScale> {
  late double scale;

  @override
  void initState() {
    scale = widget.begin;
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() => scale = widget.end);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: widget.duration,
      curve: widget.curve,
      onEnd: widget.onEnd,
      child: widget.child,
    );
  }
}
