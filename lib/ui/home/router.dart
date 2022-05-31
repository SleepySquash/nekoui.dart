import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/router.dart';
import '/util/platform_utils.dart';
import 'grocery/view.dart';
import 'neko/view.dart';
import 'room/view.dart';
import 'settings/view.dart';

/// [Routes.home] page [RouterDelegate] that builds the nested [Navigator].
///
/// [HomeRouterDelegate] doesn't parses any routes. Instead, it only uses the
/// [RouterState] passed to its constructor.
class HomeRouterDelegate extends RouterDelegate<RouteConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfiguration> {
  HomeRouterDelegate(this._state) {
    _state.addListener(notifyListeners);
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Router's application state that reflects the navigation.
  final RouterState _state;

  /// [Navigator]'s pages generation based on the [_state].
  List<Page<dynamic>> get _pages {
    /// [_NestedHomeView] is always included.
    List<Page<dynamic>> pages = [];

    for (String route in _state.routes) {
      if (route == Routes.home) {
        pages.add(MaterialPage(
          key: const ValueKey('RoomPage'),
          child: RoomView(Get.find()),
        ));
      } else if (route.startsWith(Routes.settings)) {
        pages.add(const MaterialPage(
          key: ValueKey('SettingsPage'),
          name: Routes.settings,
          child: SettingsView(),
        ));
      } else if (route == Routes.grocery) {
        pages.add(const MaterialPage(
          key: ValueKey('GroceryPage'),
          name: Routes.grocery,
          child: GroceryView(),
        ));
      }
    }

    if (pages.isEmpty) {
      return [
        const MaterialPage(
          child: Scaffold(
            body: Center(child: Text('Not found :(')),
          ),
        )
      ];
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _pages,
      onPopPage: (route, result) {
        _state.pop();
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteConfiguration configuration) async {
    // This is not required for inner router delegate because it doesn't parse
    // routes.
    assert(false, 'unexpected setNewRoutePath() call');
  }
}

/// View of the [Routes.home] page of the nested navigation.
class _NestedHomeView extends StatelessWidget {
  const _NestedHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return const Scaffold(backgroundColor: Colors.transparent);
    }

    return Scaffold(body: Center(child: Text('label_choose_chat'.tr)));
  }
}
