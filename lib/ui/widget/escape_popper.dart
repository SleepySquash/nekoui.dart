import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EscapePopper extends StatelessWidget {
  const EscapePopper({
    Key? key,
    required this.child,
    this.onEscape,
  }) : super(key: key);

  final Widget child;
  final void Function()? onEscape;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      onKeyEvent: (k) {
        if (k is KeyUpEvent && k.logicalKey == LogicalKeyboardKey.escape) {
          (onEscape ?? Navigator.of(context).pop).call();
        }
      },
      focusNode: FocusNode(),
      child: child,
    );
  }
}
