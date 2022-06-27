import 'package:flutter/material.dart';

/// Widget used to keep the state of its [child] alive.
///
/// Required in [PageView]s since switching the page resets the state of the
/// widget.
class KeepAlivePage extends StatefulWidget {
  const KeepAlivePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

/// State of a [KeepAlivePage] used to keep its state alive.
class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
