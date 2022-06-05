import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'domain/service/auth.dart';
import 'domain/service/item.dart';
import 'domain/service/neko.dart';
import 'provider/hive/item.dart';
import 'provider/hive/neko.dart';
import 'store/item.dart';
import 'store/neko.dart';
import 'ui/auth/view.dart';
import 'ui/home/view.dart';
import 'ui/widget/context_menu/overlay.dart';
import 'ui/widget/lifecycle_observer.dart';
import 'util/scoped_dependencies.dart';
import 'util/web/web_utils.dart';

/// Application's global router state.
late RouterState router;

/// Application routes names.
class Routes {
  static const auth = '/';
  static const grocery = '/grocery';
  static const groceryCheckout = '/grocery/checkout';
  static const home = '/';
}

/// Application's router state.
///
/// Any change requires [notifyListeners] to be invoked in order for the router
/// to update its state.
class RouterState extends ChangeNotifier {
  RouterState(this._auth) {
    delegate = AppRouterDelegate(this);
    parser = AppRouteInformationParser();
  }

  /// Application's [RouterDelegate].
  late final RouterDelegate<Object> delegate;

  /// Application's [RouteInformationParser].
  late final RouteInformationParser<Object> parser;

  /// Application's optional [RouteInformationProvider].
  ///
  /// [PlatformRouteInformationProvider] is used on null.
  RouteInformationProvider? provider;

  /// This router's global [BuildContext] to use in contextless scenarios.
  BuildContext? context;

  /// Reactive [AppLifecycleState].
  final Rx<AppLifecycleState> lifecycle =
      Rx<AppLifecycleState>(AppLifecycleState.resumed);

  /// Reactive title prefix of the current browser tab.
  final RxnString prefix = RxnString(null);

  /// Auth service used to determine the auth status.
  final AuthService _auth;

  /// Routes history stack.
  List<String> _routes = [];

  /// Current route (last in the [routes] history).
  String get route => _routes.lastOrNull == null ? Routes.home : _routes.last;

  /// Route history stack.
  List<String> get routes => List.unmodifiable(_routes);

  /// Sets the current [route] to [to] if guard allows it.
  ///
  /// Clears the whole [routes] stack.
  void go(String to) {
    _routes = [_guarded(to)];
    notifyListeners();
  }

  /// Pushes [to] to the [routes] stack.
  void push(String to) {
    int pageIndex = _routes.indexWhere((e) => e == to);
    if (pageIndex != -1) {
      while (_routes.length - 1 > pageIndex) {
        pop();
      }
    } else {
      _routes.add(_guarded(to));
    }

    notifyListeners();
  }

  /// Removes the last route in the [routes] history.
  ///
  /// If [routes] contain only one record, then removes segments of that record
  /// by `/` if any, otherwise replaces it with [Routes.home].
  void pop() {
    if (_routes.isNotEmpty) {
      if (_routes.length == 1) {
        String last = _routes.last.split('/').last;
        _routes.last = _routes.last.replaceFirst('/$last', '');
        if (_routes.last == '') {
          _routes.last = Routes.home;
        }
      } else {
        _routes.removeLast();
        if (_routes.isEmpty) {
          _routes.add(Routes.home);
        }
      }

      notifyListeners();
    }
  }

  /// Returns guarded route based on [_auth] status.
  ///
  /// - [Routes.home] is allowed always.
  /// - [Routes.login] is allowed to visit only on no auth status.
  /// - Any other page is allowed to visit only on success auth status.
  String _guarded(String to) {
    switch (to) {
      case Routes.home:
        return to;

      default:
        if (_auth.status.value.isSuccess) {
          return to;
        } else {
          return route;
        }
    }
  }
}

/// Application's route configuration used to determine the current router state
/// to parse from/to [RouteInformation].
class RouteConfiguration {
  RouteConfiguration(this.route, [this.loggedIn = true]);

  /// Current route as a [String] value.
  ///
  /// e.g. `/auth`, `/chat/0`, etc.
  final String route;

  /// Whether current user is logged in or not.
  bool loggedIn;
}

/// Parses the [RouteConfiguration] from/to [RouteInformation].
class AppRouteInformationParser
    extends RouteInformationParser<RouteConfiguration> {
  @override
  SynchronousFuture<RouteConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) =>
      SynchronousFuture(RouteConfiguration(routeInformation.location!));

  @override
  RouteInformation restoreRouteInformation(RouteConfiguration configuration) {
    String route = configuration.route;
    return RouteInformation(location: route);
  }
}

/// Application's router delegate that builds the root [Navigator] based on
/// the [_state].
class AppRouterDelegate extends RouterDelegate<RouteConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfiguration> {
  AppRouterDelegate(this._state) {
    _state.addListener(notifyListeners);
    _prefixWorker = ever(_state.prefix, (_) => _updateTabTitle());
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Router's state used to determine current [Navigator]'s pages.
  final RouterState _state;

  /// Worker to react on the [RouterState.prefix] changes.
  late final Worker _prefixWorker;

  @override
  Future<void> setInitialRoutePath(RouteConfiguration configuration) {
    Future.delayed(
        Duration.zero, () => _state.context = navigatorKey.currentContext);
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(RouteConfiguration configuration) async {
    _state._routes = [configuration.route];
    _state.notifyListeners();
  }

  @override
  RouteConfiguration get currentConfiguration =>
      RouteConfiguration(_state.route, _state._auth.status.value.isSuccess);

  @override
  void dispose() {
    _prefixWorker.dispose();
    super.dispose();
  }

  /// Unknown page view.
  Page<dynamic> get _notFoundPage => MaterialPage(
        key: const ValueKey('404'),
        child: Scaffold(body: Center(child: Text('label_unknown_page'.tr))),
      );

  /// [Navigator]'s pages generation based on the [_state].
  List<Page<dynamic>> get _pages {
    /// [Routes.home] or [Routes.auth] page is always included.
    List<Page<dynamic>> pages = [];

    if (_state._auth.status.value.isSuccess) {
      pages.add(MaterialPage(
        key: const ValueKey('HomePage'),
        name: Routes.home,
        child: HomeView(
          () async {
            ScopedDependencies deps = ScopedDependencies();

            await deps.put(NekoHiveProvider()).init();
            await deps.put(ItemHiveProvider()).init();

            NekoRepository nekoRepository =
                deps.put(NekoRepository(Get.find()));
            deps.put(NekoService(nekoRepository));

            ItemRepository itemRepository =
                deps.put(ItemRepository(Get.find()));
            deps.put(ItemService(itemRepository));

            return deps;
          },
        ),
      ));
    } else {
      pages.add(const MaterialPage(
        key: ValueKey('AuthPage'),
        name: Routes.auth,
        child: AuthView(),
      ));
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) => LifecycleObserver(
        didChangeAppLifecycleState: (v) => _state.lifecycle.value = v,
        child: ContextMenuOverlay(
          child: Navigator(
            key: navigatorKey,
            pages: _pages,
            onPopPage: (Route<dynamic> route, dynamic result) {
              final bool success = route.didPop(result);
              if (success) {
                _state.pop();
              }
              return success;
            },
          ),
        ),
      );

  /// Sets the browser's tab title.
  void _updateTabTitle() {
    String? prefix = _state.prefix.value;
    if (prefix != null) {
      prefix = '$prefix ';
    }
    prefix ??= '';

    WebUtils.title('Gapopa');
  }
}

/// [RouterState]'s extension shortcuts on [Routes] constants.
extension RouteLinks on RouterState {
  /// Changes router location to the [Routes.auth] page.
  void auth() => go(Routes.auth);

  /// Changes router location to the [Routes.home] page.
  void home() => go(Routes.home);

  /// Changes router location to the [Routes.grocery] page.
  void grocery() => go(Routes.grocery);

  /// Changes router location to the [Routes.groceryCheckout] page.
  void groceryCheckout() => go(Routes.groceryCheckout);
}

/// Extension adding helper methods to an [AppLifecycleState].
extension AppLifecycleStateExtension on AppLifecycleState {
  /// Indicates whether this [AppLifecycleState] is considered as a foreground.
  bool get inForeground {
    switch (this) {
      case AppLifecycleState.resumed:
        return true;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        return false;
    }
  }
}
