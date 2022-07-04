import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nekoui/domain/repository/flag.dart';
import 'package:nekoui/domain/service/environment.dart';
import 'package:nekoui/provider/hive/flag.dart';
import 'package:nekoui/store/flag.dart';

import 'domain/model/neko.dart';
import 'domain/repository/item.dart';
import 'domain/repository/neko.dart';
import 'domain/repository/skill.dart';
import 'domain/repository/trait.dart';
import 'domain/service/auth.dart';
import 'domain/service/item.dart';
import 'domain/service/neko.dart';
import 'provider/hive/item.dart';
import 'provider/hive/neko.dart';
import 'provider/hive/skill.dart';
import 'provider/hive/trait.dart';
import 'store/item.dart';
import 'store/neko.dart';
import 'store/skill.dart';
import 'store/trait.dart';
import 'ui/auth/view.dart';
import 'ui/home/router.dart';
import 'ui/home/view.dart';
import 'ui/introduction/view.dart';
import 'ui/widget/context_menu/overlay.dart';
import 'ui/widget/lifecycle_observer.dart';
import 'ui/widget/notification/view.dart';
import 'ui/worker/necessities.dart';
import 'ui/worker/skill.dart';
import 'util/scoped_dependencies.dart';
import 'util/web/web_utils.dart';

/// Application's global router state.
late RouterState router;

/// Application routes names.
class Routes {
  static const auth = '/';
  static const flowchart = '/flowchart';
  static const grocery = '/grocery';
  static const groceryCheckout = '/grocery/checkout';
  static const home = '/';
  static const introduction = '/introduction';
  static const inventory = '/inventory';
  static const map = '/map';
  static const more = '/more';
  static const park = '/park';
  static const settings = '/more/settings';
  static const wardrobe = '/wardrobe';
  static const guild = '/guild';
  static const hospital = '/hospital';
  static const monastery = '/monastery';
  static const church = '/church';
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

  /// Last [Offset] of the pointer determined in [MouseRegion].
  final Rx<Offset?> mousePosition = Rx<Offset?>(null);

  /// Reactive title prefix of the current browser tab.
  final RxnString prefix = RxnString(null);

  /// Dynamic arguments of this [RouterState].
  dynamic arguments;

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
    arguments = null;
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
  void pop([Route? route]) {
    if (_routes.isNotEmpty) {
      if (_routes.length == 1) {
        String name = route?.settings.name ?? _routes.first;
        if (_routes.first == name) {
          String last = _routes.last.split('/').last;
          _routes.last = _routes.last.replaceFirst('/$last', '');
          if (_routes.last == '') {
            _routes.last = Routes.home;
          }
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

      case Routes.introduction:
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
      pages.add(TransitionPage(
        key: const ValueKey('HomePage'),
        name: Routes.home,
        child: HomeView(
          () async {
            ScopedDependencies deps = ScopedDependencies();

            await deps.put(NekoHiveProvider()).init();
            await deps.put(ItemHiveProvider()).init();
            await deps.put(SkillHiveProvider()).init();
            await deps.put(TraitHiveProvider()).init();
            await deps.put(FlagHiveProvider()).init();

            AbstractItemRepository itemRepository =
                deps.put(ItemRepository(Get.find()));
            deps.put(ItemService(itemRepository));

            AbstractFlagRepository flagRepository =
                deps.put(FlagRepository(Get.find()));
            deps.put(EnvironmentService(flagRepository));

            AbstractTraitRepository traitRepository =
                deps.put(TraitRepository(Get.find()));
            AbstractSkillRepository skillRepository =
                deps.put(SkillRepository(Get.find()));
            AbstractNekoRepository nekoRepository = deps.put(NekoRepository(
              Get.find(),
              initial: _state.arguments is Neko ? _state.arguments : null,
            ));

            NekoService nekoService = deps.put(
                NekoService(nekoRepository, skillRepository, traitRepository));

            deps.put(SkillWorker(nekoService, Get.find()));
            deps.put(NecessitiesWorker(nekoService, Get.find()));

            return deps;
          },
        ),
      ));
    } else if (_state.route == Routes.introduction) {
      pages.add(const TransitionPage(
        key: ValueKey('IntroductionPage'),
        name: Routes.introduction,
        child: IntroductionView(),
      ));
    } else {
      pages.add(const TransitionPage(
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
          child: MouseRegion(
            opaque: false,
            onEnter: (d) => _state.mousePosition.value =
                Offset(d.localPosition.dx, d.localPosition.dy),
            onHover: (d) => _state.mousePosition.value =
                Offset(d.localPosition.dx, d.localPosition.dy),
            onExit: (d) => _state.mousePosition.value =
                Offset(d.localPosition.dx, d.localPosition.dy),
            child: NotificationOverlayView(
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
  void home({Neko? neko}) {
    go(Routes.home);
    arguments = neko;
  }

  /// Changes router location to the [Routes.grocery] page.
  void grocery() => go(Routes.grocery);

  /// Changes router location to the [Routes.groceryCheckout] page.
  void groceryCheckout() => go(Routes.groceryCheckout);

  /// Changes router location to the [Routes.flowchart] page.
  void flowchart({bool push = true}) =>
      (push ? this.push : go)(Routes.flowchart);

  /// Changes router location to the [Routes.inventory] page.
  void inventory({bool push = true}) =>
      (push ? this.push : go)(Routes.inventory);

  /// Changes router location to the [Routes.map] page.
  void map({bool push = true}) => (push ? this.push : go)(Routes.map);

  /// Changes router location to the [Routes.settings] page.
  void settings({bool push = true}) => (push ? this.push : go)(Routes.settings);

  /// Changes router location to the [Routes.more] page.
  void more({bool push = true}) => (push ? this.push : go)(Routes.more);

  /// Changes router location to the [Routes.wardrobe] page.
  void wardrobe({bool push = true}) => (push ? this.push : go)(Routes.wardrobe);

  /// Changes router location to the [Routes.park] page.
  void park() => go(Routes.park);

  /// Changes router location to the [Routes.introduction] page.
  void introduction() => go(Routes.introduction);

  /// Changes router location to the [Routes.guild] page.
  void guild() => go(Routes.guild);
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
