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
import 'package:page_transition/page_transition.dart';

import '/router.dart';
import 'flowchart/view.dart';
import 'grocery/checkout/view.dart';
import 'grocery/view.dart';
import 'guild/view.dart';
import 'inventory/view.dart';
import 'map/view.dart';
import 'more/settings/view.dart';
import 'more/view.dart';
import 'park/view.dart';
import 'room/view.dart';
import 'wardrobe/view.dart';

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
      if (route.startsWith(Routes.grocery)) {
        pages.add(const TransitionPage(
          key: ValueKey('GroceryPage'),
          name: Routes.grocery,
          child: GroceryView(),
        ));

        if (route == Routes.groceryCheckout) {
          pages.add(const MaterialPage(
            key: ValueKey('GroceryCheckoutPage'),
            name: Routes.groceryCheckout,
            child: GroceryCheckoutView(),
          ));
        }
      } else if (route.startsWith(Routes.park)) {
        pages.add(const TransitionPage(
          key: ValueKey('ParkPage'),
          name: Routes.park,
          child: ParkView(),
        ));
      } else if (route == Routes.home) {
        pages.add(const TransitionPage(
          key: ValueKey('RoomPage'),
          name: Routes.home,
          child: RoomView(),
        ));
      } else if (route == Routes.more) {
        pages.add(const TransitionPage(
          key: ValueKey('MorePage'),
          name: Routes.more,
          child: MoreView(),
        ));
      } else if (route == Routes.settings) {
        pages.add(const MaterialPage(
          key: ValueKey('SettingsPage'),
          name: Routes.settings,
          child: SettingsView(),
        ));
      } else if (route == Routes.inventory) {
        pages.add(const TransitionPage(
          key: ValueKey('InventoryPage'),
          name: Routes.inventory,
          child: InventoryView(),
        ));
      } else if (route == Routes.wardrobe) {
        pages.add(const TransitionPage(
          key: ValueKey('WardrobePage'),
          name: Routes.wardrobe,
          child: WardrobeView(),
        ));
      } else if (route == Routes.flowchart) {
        pages.add(const TransitionPage(
          key: ValueKey('FlowchartPage'),
          name: Routes.flowchart,
          child: FlowchartView(),
        ));
      } else if (route == Routes.map) {
        pages.add(const TransitionPage(
          key: ValueKey('MapPage'),
          name: Routes.map,
          child: MapView(),
        ));
      } else if (route == Routes.guild) {
        pages.add(const TransitionPage(
          key: ValueKey('GuildPage'),
          name: Routes.guild,
          child: GuildView(),
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
        _state.pop(route);
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

class TransitionPage<T> extends Page<T> {
  const TransitionPage({
    required this.child,
    this.type = PageTransitionType.fade,
    this.maintainState = true,
    this.fullscreenDialog = false,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) : super(
          key: key,
          name: name,
          arguments: arguments,
          restorationId: restorationId,
        );

  /// The content to be shown in the [Route] created by this page.
  final Widget child;

  /// {@macro flutter.widgets.ModalRoute.maintainState}
  final bool maintainState;

  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  final bool fullscreenDialog;

  final PageTransitionType type;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageTransition(
      type: type,
      settings: this,
      child: child,
    );
  }
}
