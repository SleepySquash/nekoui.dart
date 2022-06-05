import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimatedAppearance extends StatefulWidget {
  const AnimatedAppearance({
    Key? key,
    required this.beginOpacity,
    required this.endOpacity,
    required this.child,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 500),
    this.onEnd,
  }) : super(key: key);

  final double beginOpacity;
  final double endOpacity;

  final Curve curve;
  final Duration duration;

  final VoidCallback? onEnd;
  final Widget child;

  @override
  State<AnimatedAppearance> createState() => _AnimatedAppearanceState();
}

class _AnimatedAppearanceState extends State<AnimatedAppearance> {
  late double _opacity;

  @override
  void initState() {
    _opacity = widget.beginOpacity;

    if (widget.duration == Duration.zero) {
      _opacity = widget.endOpacity;
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _opacity = widget.endOpacity;
          });
        }
      });
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnimatedAppearance oldWidget) {
    if (widget.endOpacity != oldWidget.endOpacity) {
      setState(() {
        _opacity = widget.endOpacity;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.duration,
      curve: widget.curve,
      onEnd: widget.onEnd,
      child: widget.child,
    );
  }
}
