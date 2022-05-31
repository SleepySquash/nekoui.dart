import 'package:flutter/widgets.dart';

/// Wrapper to prevent a default web context menu over its [child].
class ContextMenuInterceptor extends StatelessWidget {
  const ContextMenuInterceptor({
    required this.child,
    enabled = true,
    debug = false,
    Key? key,
  }) : super(key: key);

  /// Widget being wrapped.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
