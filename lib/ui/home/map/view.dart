import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nekoui/router.dart';

import 'controller.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  /// Displays a dialog with the provided [novel] above the current contents.
  static Future<T?> show<T extends Object?>({required BuildContext context}) {
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
        return themes.wrap(const MapView());
      },
      barrierDismissible: false,
      transitionDuration: 300.milliseconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MapController(),
      builder: (MapController c) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Location(
                'home',
                icon: Icons.home,
                onTap: router.home,
              ),
              Location(
                'grocery',
                icon: Icons.local_grocery_store,
                onTap: router.grocery,
              ),
              Location(
                'shopkeeper',
                icon: Icons.shop,
                onTap: () {},
              ),
              Location(
                'job',
                icon: Icons.shop,
                onTap: () {},
              ),
              Location(
                'park',
                icon: Icons.park,
                onTap: () {},
              ),
              Location(
                'neko_science',
                icon: Icons.science_rounded,
                onTap: () {},
              ),
            ]
                .map(
                  (e) => ListTile(
                    leading: Icon(e.icon),
                    title: Text(e.id),
                    onTap: () {
                      e.onTap?.call();
                      Navigator.of(context).pop();
                    },
                  ),
                )
                .toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: Navigator.of(context).pop,
            child: const Icon(Icons.close),
          ),
        );
      },
    );
  }
}
