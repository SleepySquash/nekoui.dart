import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/novel/novel.dart';

import '/domain/service/neko.dart';
import '/ui/widget/backdrop_button.dart';
import '/ui/widget/conditional_backdrop.dart';
import '/ui/widget/neko.dart';

import 'controller.dart';

class NekoView extends StatefulWidget {
  const NekoView(
    this._neko, {
    Key? key,
    this.globalKey,
  }) : super(key: key);

  final GlobalKey? globalKey;

  final NekoService _neko;

  /// Displays a dialog with the provided [gallery] above the current contents.
  static Future<T?> show<T extends Object?>({
    required BuildContext context,
    required NekoView view,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        final CapturedThemes themes = InheritedTheme.capture(
          from: context,
          to: Navigator.of(context, rootNavigator: true).context,
        );
        return themes.wrap(view);
      },
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
    );
  }

  @override
  State<NekoView> createState() => _NekoViewState();
}

class _NekoViewState extends State<NekoView>
    with SingleTickerProviderStateMixin {
  /// [AnimationController] controlling the opening and closing animation.
  late final AnimationController _fading;

  /// Pops this [NekoView] route off the [Navigator].
  void Function()? _pop;

  /// [Rect] of an [Object] to animate this [NekoView] from/to.
  late Rect _bounds;

  /// Discard the first [LayoutBuilder] frame since no widget is drawn yet.
  bool _firstLayout = true;

  @override
  void initState() {
    _fading = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )
      ..addStatusListener(
        (status) {
          switch (status) {
            case AnimationStatus.dismissed:
              _pop?.call();
              break;

            case AnimationStatus.reverse:
            case AnimationStatus.forward:
            case AnimationStatus.completed:
              // No-op.
              break;
          }
        },
      )
      ..forward();

    _bounds = _calculatePosition() ?? Rect.zero;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_firstLayout) {
          _pop = Navigator.of(context).pop;
          _firstLayout = false;
        }

        var curved = CurvedAnimation(
          parent: _fading,
          curve: Curves.ease,
          reverseCurve: Curves.ease,
        );

        var fade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _fading,
          curve: const Interval(0, 0.3, curve: Curves.ease),
        ));

        RelativeRectTween tween() => RelativeRectTween(
              begin: RelativeRect.fromSize(_bounds, constraints.biggest),
              end: RelativeRect.fill,
            );

        return GetBuilder(
          init: NekoController(),
          builder: (NekoController c) {
            return Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (c.screen.value == null) {
                      _dismiss();
                    } else {
                      c.screen.value = null;
                    }
                  },
                  child: AnimatedBuilder(
                    animation: _fading,
                    builder: (context, child) => ConditionalBackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 0.1 + 15 * _fading.value,
                        sigmaY: 0.1 + 15 * _fading.value,
                      ),
                      child: Container(),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _fading,
                  builder: (context, child) {
                    return PositionedTransition(
                      rect: tween().animate(curved),
                      child: FadeTransition(
                        opacity: fade,
                        child: NekoWidget(widget._neko),
                      ),
                    );
                  },
                ),
                ..._buildInterface(c),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> _buildInterface(NekoController c) {
    Widget screen(NekoViewScreen? current) {
      switch (current) {
        case NekoViewScreen.ask:
        case NekoViewScreen.action:
        case NekoViewScreen.activity:
          return Container();

        case NekoViewScreen.talk:
          var topics = [
            BackdropBubble(
              text: 'Мне нравится твоя улыбка',
              icon: Icons.favorite,
              color: Colors.red,
              onTap: () {
                Novel.show(
                  context: context,
                  scenario: Scenario(
                    [
                      ScenarioAddLine(BackdropRect(), wait: false),
                      ScenarioAddLine(
                        Character('person.png', duration: Duration.zero),
                        wait: false,
                      ),
                      ScenarioAddLine(Dialogue(
                        by: 'Vanilla',
                        text: 'Ух ты!',
                      )),
                    ],
                  ),
                );
              },
            ),
            BackdropBubble(
              text: 'Как дела с учёбой?',
              icon: Icons.school,
              color: Colors.blueGrey,
              onTap: () {
                Novel.show(
                  context: context,
                  scenario: Scenario(
                    [
                      ScenarioAddLine(BackdropRect(), wait: false),
                      ScenarioAddLine(
                        Character('person.png', duration: Duration.zero),
                        wait: false,
                      ),
                      ScenarioAddLine(Dialogue(
                        by: 'Vanilla',
                        text: 'Памаги...',
                      )),
                    ],
                  ),
                );
              },
            ),
            BackdropBubble(
              text: 'Проголодалась?',
              icon: Icons.fastfood,
              color: Colors.orange,
            ),
            BackdropBubble(
              text: 'Хочешь чем-нибудь заняться?',
              icon: Icons.people,
              color: Colors.pink,
            ),
            BackdropBubble(
              text: 'Как тебе "Тортик"?',
              icon: Icons.fastfood,
              color: Colors.orange,
            ),
            BackdropBubble(
              text: 'Про теорему Пифагора',
              icon: Icons.school,
              color: Colors.blueGrey,
            ),
            BackdropBubble(
              text: 'Как ты любишь проводить время?',
              icon: Icons.chat,
              color: Colors.blue,
            ),
          ];

          bool left = true;

          List<Widget> rows = [];

          for (var e in topics) {
            rows.add(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (left) const Spacer(flex: 10),
                  Flexible(flex: 10, child: e),
                  if (!left) const Spacer(flex: 10),
                ],
              ),
            );

            left = !left;
          }

          return Stack(
            children: [
              Center(
                key: const Key('TalkSelection'),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: rows
                        .map((e) => Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: e,
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BackdropIconButton(
                    icon: Icons.chat,
                    color: Colors.blue.withOpacity(0.4),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          );

        default:
          return Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: BackdropIconButton(
                      icon: Icons.help,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: BackdropIconButton(
                      icon: Icons.chat_rounded,
                      onTap: () => c.screen.value = NekoViewScreen.talk,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: BackdropIconButton(
                      icon: Icons.attractions,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: BackdropIconButton(
                      icon: Icons.handshake_rounded,
                      onTap: () {
                        Novel.show(
                          context: context,
                          scenario: Scenario(
                            [
                              ScenarioAddLine(
                                Background('park.jpg'),
                                wait: false,
                              ),
                              ScenarioAddLine(Character('person.png')),
                              ScenarioAddLine(Dialogue(
                                by: 'Vanilla',
                                text: 'Hello, I am Vanilla!',
                              )),
                              ScenarioAddLine(Dialogue(
                                by: 'Vanilla',
                                text: 'And you?',
                              )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
      }
    }

    return [
      AnimatedBuilder(
        animation: _fading,
        builder: (_, child) => Opacity(opacity: _fading.value, child: child!),
        child: Obx(
          () => AnimatedSwitcher(
            duration: 200.milliseconds,
            child: screen(c.screen.value),
          ),
        ),
      ),
      AnimatedBuilder(
        animation: _fading,
        builder: (_, child) => Opacity(opacity: _fading.value, child: child!),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 37, right: 37),
            child: Obx(
              () => FloatingActionButton(
                mini: true,
                onPressed: c.screen.value == null
                    ? _dismiss
                    : () => c.screen.value = null,
                child: c.screen.value == null
                    ? const Icon(Icons.close_rounded)
                    : const Icon(Icons.arrow_back),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  /// Starts a dismiss animation.
  void _dismiss() {
    _bounds = _calculatePosition() ?? _bounds;
    _fading.reverse();
  }

  /// Returns a [Rect] of an [Object] identified by the provided initial
  /// [GlobalKey].
  Rect? _calculatePosition() => widget.globalKey?.globalPaintBounds;
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final matrix = renderObject?.getTransformTo(null);

    if (matrix != null && renderObject?.paintBounds != null) {
      final rect = MatrixUtils.transformRect(matrix, renderObject!.paintBounds);
      return rect;
    } else {
      return null;
    }
  }
}
