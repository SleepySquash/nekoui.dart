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
