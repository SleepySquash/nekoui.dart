import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/router.dart';
import '/ui/widget/escape_popper.dart';
import 'controller.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EscapePopper(
      child: GetBuilder(
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
                  onTap: router.park,
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
      ),
    );
  }
}
