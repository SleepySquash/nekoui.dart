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
                const Location(
                  'restaurant',
                  icon: Icons.restaurant,
                  onTap: null,
                ),
                const Location(
                  'shopkeeper',
                  icon: Icons.shop,
                  onTap: null,
                ),
                const Location(
                  'job',
                  icon: Icons.shop,
                  onTap: null,
                ),
                Location(
                  'park',
                  icon: Icons.park,
                  onTap: router.park,
                ),
                const Location(
                  'neko_science',
                  icon: Icons.science_rounded,
                  onTap: null,
                ),
                const Location(
                  'church',
                  icon: Icons.church,
                  onTap: null,
                ),
                const Location(
                  'monastery',
                  icon: Icons.church_outlined,
                  onTap: null,
                ),
                const Location(
                  'school',
                  icon: Icons.school_outlined,
                  onTap: null,
                ),
                const Location(
                  'university',
                  icon: Icons.school,
                  onTap: null,
                ),
                const Location(
                  'hospital',
                  icon: Icons.local_hospital,
                  onTap: null,
                ),
                Location(
                  'guild',
                  icon: Icons.biotech,
                  onTap: router.guild,
                ),
              ]
                  .map(
                    (e) => ListTile(
                      leading: Icon(e.icon),
                      title: Text(e.id),
                      enabled: e.onTap != null,
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
