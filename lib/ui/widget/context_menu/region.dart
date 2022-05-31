import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../menu_interceptor/menu_interceptor.dart';
import 'overlay.dart';

/// Region of a context [menu] over a [child], showed on a secondary mouse click
/// or a long tap.
class ContextMenuRegion extends StatefulWidget {
  const ContextMenuRegion({
    Key? key,
    required this.child,
    required this.menu,
    this.enabled = true,
    this.preventContextMenu = true,
  }) : super(key: key);

  /// Widget to wrap this region over.
  final Widget child;

  /// Context menu to show.
  final Widget menu;

  /// Indicator whether this region should be enabled.
  final bool enabled;

  /// Indicator whether a default context menu should be prevented or not.
  ///
  /// Only effective under the web, since only web has a default context menu.
  final bool preventContextMenu;

  @override
  State<ContextMenuRegion> createState() => _ContextMenuRegionState();
}

/// State of [ContextMenuRegion] used to keep track of [_buttons].
class _ContextMenuRegionState extends State<ContextMenuRegion> {
  /// Bit field of [PointerDownEvent]'s buttons.
  ///
  /// [PointerUpEvent] doesn't contain the button being released, so it's
  /// required to store the buttons from.
  int _buttons = 0;

  @override
  Widget build(BuildContext context) => widget.enabled
      ? ContextMenuInterceptor(
          enabled: widget.preventContextMenu,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (d) => _buttons = d.buttons,
            onPointerUp: (d) {
              if (_buttons & kSecondaryButton != 0) {
                ContextMenuOverlay.of(context).show(widget.menu, d.position);
              }
            },
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPressStart: (d) => ContextMenuOverlay.of(context)
                  .show(widget.menu, d.globalPosition),
              child: widget.child,
            ),
          ),
        )
      : widget.child;
}
