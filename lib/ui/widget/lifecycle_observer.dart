import 'package:flutter/material.dart';

/// Reporter of [AppLifecycleState] changes via a [didChangeAppLifecycleState].
class LifecycleObserver extends StatefulWidget {
  const LifecycleObserver({
    Key? key,
    required this.child,
    this.didChangeAppLifecycleState,
  }) : super(key: key);

  /// [Widget] to wrap this [LifecycleObserver] into.
  final Widget child;

  /// Callback, called when the [AppLifecycleState] is changed.
  final void Function(AppLifecycleState state)? didChangeAppLifecycleState;

  @override
  State<LifecycleObserver> createState() => _LifecycleObserverState();
}

/// State of a [LifecycleObserver] used to observe the [AppLifecycleState].
class _LifecycleObserverState extends State<LifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.didChangeAppLifecycleState?.call(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
