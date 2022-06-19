import 'package:flutter/material.dart';

class AnimatedDelayedSlide extends StatefulWidget {
  const AnimatedDelayedSlide({
    Key? key,
    this.begin = const Offset(1, 0),
    this.end = Offset.zero,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.linearToEaseOut,
    this.onEnd,
  }) : super(key: key);

  final Offset begin;
  final Offset end;
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final void Function()? onEnd;

  @override
  State<AnimatedDelayedSlide> createState() => _AnimatedDelayedSlideState();
}

class _AnimatedDelayedSlideState extends State<AnimatedDelayedSlide> {
  late Offset offset;

  @override
  void initState() {
    offset = widget.begin;
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() => offset = widget.end);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: offset,
      duration: widget.duration,
      curve: widget.curve,
      onEnd: widget.onEnd,
      child: widget.child,
    );
  }
}
